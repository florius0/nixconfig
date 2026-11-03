{ config, ... }:

{
  services.ollama = {
    enable = true;

    loadModels = { };

    environmentVariables = {
      OLLAMA_MODELS = "${config.xdg.dataHome}/ollama/models";
      OLLAMA_KEEP_ALIVE = "2m";
      OLLAMA_NUM_PARALLEL = "1";
    };
  };
}
