{ config, ... }:

{
  services.ollama = {
    enable = true;

    loadModels = {
      # Main local coding / agent model.
      qwen-coding = {
        from = "qwen3.6:35b-a3b-coding-nvfp4";
        parameters.num_ctx = 65536;
      };

      # Cheap/fast model for simple questions, routing,
      # summarization and lightweight subagents.
      gemma-fast = {
        from = "gemma4:e4b-mlx";
        parameters.num_ctx = 32768;
      };

      # Stronger general-purpose local model:
      # explanations, architecture, reasoning, code review.
      gemma-general = {
        from = "gemma4:26b-mlx";
        parameters.num_ctx = 65536;
      };
    };

    environmentVariables = {
      OLLAMA_MODELS = "${config.xdg.dataHome}/ollama/models";
      OLLAMA_KEEP_ALIVE = "2m";
      OLLAMA_NUM_PARALLEL = "1";
    };
  };
}
