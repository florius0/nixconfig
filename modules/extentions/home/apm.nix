{
  config,
  flake,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
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
  bundle = pkgs.callPackage ../../../packages/apm-bundle/builder.nix {
    apmPackage = cfg.package;
    inherit (cfg) packages targets compileRootContext;
  };

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
