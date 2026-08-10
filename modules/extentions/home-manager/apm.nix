{
  config,
  flake,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    getExe
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    optionalString
    types
    ;

  cfg = config.programs.apm;
  targetCatalog = [
    "agent-skills"
    "codex"
  ];

  sourceType = types.submodule {
    options = {
      type = mkOption {
        type = types.enum [
          "github"
          "git"
        ];
        description = "Nix fetcher to use for this immutable package source.";
      };
      owner = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "GitHub owner; required for github sources.";
      };
      repo = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "GitHub repository; required for github sources.";
      };
      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Git clone URL; required for generic git sources.";
      };
      rev = mkOption {
        type = types.str;
        description = "Exact Git revision selected by Nix.";
      };
      hash = mkOption {
        type = types.str;
        description = "Nix fixed-output hash for the selected source.";
      };
    };
  };

  packageType = types.submodule {
    options = {
      source = mkOption {
        type = types.nullOr sourceType;
        default = null;
        description = "A GitHub or generic Git source fetched by Nix.";
      };
      src = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "A local or existing store path escape hatch.";
      };
      path = mkOption {
        type = types.str;
        default = ".";
        description = "Relative package directory inside the fetched source.";
      };
    };
  };

  pathIsSafe =
    path:
    path != ""
    && !(lib.hasPrefix "/" path)
    && !(builtins.any (part: part == "..") (lib.splitString "/" path));

  fetchedSource =
    name: package:
    if package.src != null then
      package.src
    else if package.source.type == "github" then
      pkgs.fetchFromGitHub {
        inherit (package.source)
          owner
          repo
          rev
          hash
          ;
        name = "apm-source-${name}";
      }
    else
      pkgs.fetchgit {
        inherit (package.source) url rev hash;
        name = "apm-source-${name}";
      };

  normalizedPackages = mapAttrsToList (
    name: package:
    let
      source = fetchedSource name package;
      packagePath = lib.removePrefix "./" package.path;
    in
    {
      inherit name source packagePath;
      root = if packagePath == "." then source else "${source}/${packagePath}";
    }
  ) cfg.packages;

  yaml = pkgs.formats.yaml { };
  manifest = yaml.generate "apm.yml" {
    name = "nix-managed-agent-environment";
    version = "1.0.0";
    targets = cfg.targets;
    dependencies.apm = map (package: { path = package.root; }) normalizedPackages;
  };

  bundle =
    pkgs.runCommand "nix-managed-apm-bundle"
      {
        nativeBuildInputs = [ cfg.package ];
      }
      ''
        set -eu

        work="$TMPDIR/apm-work"
        home="$TMPDIR/home"
        mkdir -p "$work" "$home" "$TMPDIR/cache"
        export HOME="$home"
        export XDG_CONFIG_HOME="$home/.config"
        export XDG_DATA_HOME="$home/.local/share"
        export XDG_CACHE_HOME="$TMPDIR/cache"
        mkdir -p "$HOME/.apm"

        cp ${manifest} "$work/apm.yml"
        cd "$work"
        ${getExe cfg.package} install \
          --only apm \
          --target ${lib.escapeShellArg (concatStringsSep "," cfg.targets)} \
          --root "$work"

        ${optionalString cfg.compileRootContext ''
          ${getExe cfg.package} compile \
            --target ${lib.escapeShellArg (concatStringsSep "," cfg.targets)} \
            --root "$work"
        ''}

        # Keep only immutable primitive trees. APM's lockfile, module cache,
        # synthetic HOME, hooks, MCP files, and broad harness settings stay out.
        mkdir -p "$out/.agents/skills" "$out/.codex/agents" "$out/.codex/prompts"
        [ ! -d "$work/.agents/skills" ] || cp -R "$work/.agents/skills/." "$out/.agents/skills/"
        [ ! -d "$work/.codex/agents" ] || cp -R "$work/.codex/agents/." "$out/.codex/agents/"
        [ ! -d "$work/.codex/prompts" ] || cp -R "$work/.codex/prompts/." "$out/.codex/prompts/"
        ${optionalString cfg.compileRootContext ''
          [ ! -f "$work/AGENTS.md" ] || cp "$work/AGENTS.md" "$out/AGENTS.md"
        ''}
      '';

  hasSkillsTarget = builtins.elem "agent-skills" cfg.targets || builtins.elem "codex" cfg.targets;
  hasCodexTarget = builtins.elem "codex" cfg.targets;
in
{
  options.programs.apm = {
    enable = mkEnableOption "Nix-managed Microsoft Agent Package Manager assets";

    package = mkOption {
      type = types.package;
      default = flake.inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.apm;
      defaultText = lib.literalExpression "inputs.llm-agents.packages.<system>.apm";
      description = "APM compiler package; sources are resolved by Nix instead.";
    };

    targets = mkOption {
      type = types.listOf (types.enum targetCatalog);
      default = [ "agent-skills" ];
      description = "Explicit APM targets; filesystem auto-detection is not used.";
    };

    packages = mkOption {
      type = types.attrsOf packageType;
      default = { };
      description = "Agent packages fetched and pinned by Nix.";
    };

    compileRootContext = mkOption {
      type = types.bool;
      default = false;
      description = "Opt into APM instruction compilation and ownership of AGENTS.md.";
    };
  };

  config = mkIf cfg.enable {
    assertions =
      (mapAttrsToList (name: package: {
        assertion = (package.source != null) != (package.src != null);
        message = "programs.apm.packages.${name} must set exactly one of source or src.";
      }) cfg.packages)
      ++ (mapAttrsToList (name: package: {
        assertion =
          package.source == null
          || (
            if package.source.type == "github" then
              package.source.owner != null && package.source.repo != null
            else
              package.source.url != null
          );
        message = "programs.apm.packages.${name}.source must provide owner/repo for github or url for git.";
      }) cfg.packages)
      ++ (mapAttrsToList (name: package: {
        assertion = pathIsSafe package.path;
        message = "programs.apm.packages.${name}.path must be relative and contain no '..' component.";
      }) cfg.packages);

    home.packages = [ cfg.package ];

    home.file = lib.mkMerge [
      (mkIf hasSkillsTarget {
        ".agents/skills" = {
          source = "${bundle}/.agents/skills";
          recursive = true;
        };
      })
      (mkIf hasCodexTarget {
        ".codex/agents" = {
          source = "${bundle}/.codex/agents";
          recursive = true;
        };
        ".codex/prompts" = {
          source = "${bundle}/.codex/prompts";
          recursive = true;
        };
      })
      (mkIf cfg.compileRootContext {
        "AGENTS.md" = {
          source = "${bundle}/AGENTS.md";
        };
      })
    ];
  };
}

# Example:
# programs.apm.packages.frontend-design = {
#   source = {
#     type = "github";
#     owner = "anthropics";
#     repo = "skills";
#     rev = "<exact commit>";
#     hash = "sha256-<fixed-output-hash>";
#   };
#   path = "skills/frontend-design";
# };
