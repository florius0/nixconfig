{
  lib,
  pkgs,
  apmPackage,
  packages,
  targets,
  compileRootContext,
}:

# Fetches every declared package source, renders the apm.yml manifest, and
# builds the immutable APM output tree (.agents/skills, .codex/agents,
# .codex/prompts, AGENTS.md). Not autowired: args are config-shaped and only
# make sense supplied by the `programs.apm` home-manager module.
let
  inherit (lib)
    concatMapStringsSep
    concatStringsSep
    mapAttrsToList
    optionalString
    ;

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
  ) packages;

  yaml = pkgs.formats.yaml { };
  manifest = yaml.generate "apm.yml" {
    name = "nix-managed-agent-environment";
    version = "1.0.0";
    inherit targets;
    dependencies.apm = map (package: { path = "./sources/${package.name}"; }) normalizedPackages;
  };
in
pkgs.runCommand "nix-managed-apm-bundle"
  {
    nativeBuildInputs = [ apmPackage ];
  }
  ''
    set -eu

    work="$TMPDIR/apm-work"
    home="$TMPDIR/home"
    mkdir -p "$work/sources" "$home" "$TMPDIR/cache"
    ${concatMapStringsSep "\n" (package: ''
      cp -R ${lib.escapeShellArg package.root} "$work/sources/"${lib.escapeShellArg package.name}
      chmod -R u+rwX "$work/sources/"${lib.escapeShellArg package.name}
    '') normalizedPackages}
    export HOME="$home"
    export XDG_CONFIG_HOME="$home/.config"
    export XDG_DATA_HOME="$home/.local/share"
    export XDG_CACHE_HOME="$TMPDIR/cache"
    mkdir -p "$HOME/.apm"

    cp ${manifest} "$work/apm.yml"
    cd "$work"
    ${lib.getExe apmPackage} install \
      --only apm \
      --target ${lib.escapeShellArg (concatStringsSep "," targets)} \
      --root "$work"

    ${optionalString compileRootContext ''
      ${lib.getExe apmPackage} compile \
        --target ${lib.escapeShellArg (concatStringsSep "," targets)} \
        --root "$work"
    ''}

    # Keep only immutable primitive trees. APM's lockfile, module cache,
    # synthetic HOME, hooks, MCP files, and broad harness settings stay out.
    mkdir -p "$out/.agents/skills" "$out/.codex/agents" "$out/.codex/prompts"
    [ ! -d "$work/.agents/skills" ] || cp -R "$work/.agents/skills/." "$out/.agents/skills/"
    [ ! -d "$work/.codex/agents" ] || cp -R "$work/.codex/agents/." "$out/.codex/agents/"
    [ ! -d "$work/.codex/prompts" ] || cp -R "$work/.codex/prompts/." "$out/.codex/prompts/"
    ${optionalString compileRootContext ''
      [ ! -f "$work/AGENTS.md" ] || cp "$work/AGENTS.md" "$out/AGENTS.md"
    ''}
  ''
