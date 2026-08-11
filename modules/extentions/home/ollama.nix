{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    types
    ;

  cfg = config.services.ollama;
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

  modelLoader = pkgs.callPackage ../../../packages/ollama-model-loader/builder.nix {
    inherit (cfg) package acceleration host port loadModels;
    cleanup = cfg.onActivation.cleanup;
  };

  environmentVariables = cfg.environmentVariables // {
    OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
  };
in
{
  options.services.ollama = {
    loadModels = mkOption {
      type = types.attrsOf (
        types.submodule (
          { ... }:
          {
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
