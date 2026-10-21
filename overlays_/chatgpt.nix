final: prev: {
  chatgpt = prev.chatgpt.overrideAttrs (_: {
    version = "26.1013.40934";
    src = final.fetchurl {
      url = "https://persistent.oaistatic.com/codex-app-prod/ChatGPT-darwin-arm64-26.1013.40934.zip";
      hash = "sha256-FDicnpvXhxox44AIn4vFTgfGJwUPZ27NqlZ7JpKfehs=";
    };
  });
}
