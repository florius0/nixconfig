{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    escapeShellArg
    getExe
    mapAttrsToList
    mkIf
    mkOption
    optionalString
    types
    ;

  cfg = config.services.ollama;
  ollamaPackage =
    if cfg.acceleration == null then
      cfg.package
    else
      cfg.package.override { inherit (cfg) acceleration; };

  scalarType = types.oneOf [
    types.str
    types.int
    types.float
    types.bool
  ];
  parameterType = types.oneOf [
    scalarType
    (types.listOf scalarType)
  ];

  renderScalar =
    value:
    if builtins.isString value then
      builtins.toJSON value
    else if builtins.isBool value then
      (if value then "true" else "false")
    else
      toString value;

  renderParameter =
    name: value:
    let
      values = if builtins.isList value then value else [ value ];
    in
    concatStringsSep "\n" (map (item: "PARAMETER ${name} ${renderScalar item}") values);

  renderMultiline = keyword: value: ''
    ${keyword} """
    ${value}
    """
  '';

  normalizedModels = mapAttrsToList (
    finalName: model:
    let
      sourceName = if model.from == null then finalName else model.from;
      isDerived =
        model.from != null
        || model.parameters != { }
        || model.system != null
        || model.template != null
        || model.requires != null
        || model.modelfile != null;
      modelfile =
        pkgs.writeText "ollama-${builtins.replaceStrings [ ":" "/" ] [ "-" "-" ] finalName}.Modelfile"
          (
            concatStringsSep "\n" (
              [ "FROM ${sourceName}" ]
              ++ mapAttrsToList renderParameter model.parameters
              ++ lib.optional (model.system != null) (renderMultiline "SYSTEM" model.system)
              ++ lib.optional (model.template != null) (renderMultiline "TEMPLATE" model.template)
              ++ lib.optional (model.requires != null) "REQUIRES ${model.requires}"
              ++ lib.optional (model.modelfile != null) model.modelfile
            )
            + "\n"
          );
    in
    {
      inherit
        finalName
        sourceName
        isDerived
        modelfile
        ;
    }
  ) cfg.loadModels;

  sourcesToPull = lib.unique (map (model: model.sourceName) normalizedModels);
  derivedModels = builtins.filter (model: model.isDerived) normalizedModels;
  declaredModels = pkgs.writeText "ollama-declared-models" (
    concatStringsSep "\n" (map (model: model.finalName) normalizedModels) + "\n"
  );

  modelLoader = pkgs.writeShellScript "ollama-model-loader" ''
    set -eu

    OLLAMA="${getExe ollamaPackage}"
    OLLAMA_API="http://${cfg.host}:${toString cfg.port}"

    attempt=0
    until ${pkgs.curl}/bin/curl -fsS --max-time 2 "$OLLAMA_API/api/tags" >/dev/null; do
      attempt=$((attempt + 1))
      if [ "$attempt" -ge 60 ]; then
        echo "Ollama did not become reachable at $OLLAMA_API" >&2
        exit 1
      fi
      /bin/sleep 2
    done

    ${concatStringsSep "\n" (
      map (source: "${escapeShellArg (getExe ollamaPackage)} pull ${escapeShellArg source}") sourcesToPull
    )}

    ${concatStringsSep "\n" (
      map (
        model:
        "${escapeShellArg (getExe ollamaPackage)} create ${escapeShellArg model.finalName} -f ${escapeShellArg model.modelfile}"
      ) derivedModels
    )}

    ${optionalString (cfg.onActivation.cleanup == "uninstall") ''
      is_declared() {
        while IFS= read -r declared; do
          [ "$1" = "$declared" ] && return 0
          case "$declared" in
            *:*) ;;
            *) [ "$1" = "$declared:latest" ] && return 0 ;;
          esac
        done < ${escapeShellArg declaredModels}
        return 1
      }

      model_list="$(${getExe ollamaPackage} list)" || exit 1
      while IFS= read -r model; do
        [ -n "$model" ] || continue
        if ! is_declared "$model"; then
          ${getExe ollamaPackage} rm "$model"
        fi
      done < <(printf '%s\n' "$model_list" | tail -n +2 | awk '{print $1}')
    ''}
  '';

  environmentVariables = cfg.environmentVariables // {
    OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
  };
in
{
  options.services.ollama = {
    loadModels = mkOption {
      type = types.attrsOf (
        types.submodule (
          { ... }: {
            options = {
              from = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Source model to pull before creating this model.";
              };
              parameters = mkOption {
                type = types.attrsOf parameterType;
                default = { };
                description = "Modelfile PARAMETER values; lists produce repeated lines.";
              };
              system = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Multiline Modelfile SYSTEM content.";
              };
              template = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Multiline Modelfile TEMPLATE content.";
              };
              requires = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Modelfile REQUIRES value.";
              };
              modelfile = mkOption {
                type = types.nullOr types.lines;
                default = null;
                description = "Raw Modelfile text appended after generated directives.";
              };
            };
          }
        )
      );
      default = { };
      description = ''
        Models to pull and optionally derive declaratively. An empty model
        definition pulls the attrset key as a plain model.
      '';
    };

    onActivation.cleanup = mkOption {
      type = types.enum [
        "none"
        "uninstall"
      ];
      default = "none";
      description = "Whether to uninstall visible models not declared in loadModels.";
    };
  };

  config = {
    services.ollama = {
      enable = true;
      environmentVariables = {
        OLLAMA_KEEP_ALIVE = "2m";
        OLLAMA_MAX_LOADED_MODELS = "1";
      };
    };

    # Ollama does not use XDG for its model store by default. Keep the server,
    # loader, and interactive CLI on the same large model directory.
    services.ollama.environmentVariables.OLLAMA_MODELS = lib.mkDefault "${config.xdg.dataHome}/ollama/models";
    home.sessionVariables = cfg.environmentVariables;

    launchd.agents.ollama-models = mkIf (cfg.loadModels != { }) {
      enable = true;
      config = {
        ProgramArguments = [ "${modelLoader}" ];
        EnvironmentVariables = environmentVariables;
        RunAtLoad = true;
        StartInterval = 300;
        ProcessType = "Background";
      };
    };
  };
}

# Example:
# services.ollama = {
#   enable = true;
#   loadModels = {
#     qwen-coding = {
#       from = "qwen3.6:35b-a3b-coding-nvfp4";
#       parameters.num_ctx = 65536;
#     };
#     "gemma4:26b" = {};
#   };
#   onActivation.cleanup = "uninstall";
#   environmentVariables.OLLAMA_MODELS = "${config.xdg.dataHome}/ollama/models";
# };
