final: prev: {
  chatgpt = prev.chatgpt.overrideAttrs (_: {
    version = "26.928.21956";
    src = final.fetchurl {
      url = "https://persistent.oaistatic.com/codex-app-prod/ChatGPT-darwin-arm64-26.928.21956.zip";
      hash = "sha256-sPGkPn6lm2mMrdlQMfr1eqUcYnJpvApXUvW44djfc84=";
    };
  });
}
