final: prev: {
  chatgpt = prev.chatgpt.overrideAttrs (_: {
    version = "26.901.51231";
    src = final.fetchurl {
      url = "https://persistent.oaistatic.com/codex-app-prod/ChatGPT-darwin-arm64-26.901.51231.zip";
      hash = "sha256-jdxODw58gCTWQWn4TPVMVEd40di/6h/9PCsNLj6oWTQ=";
    };
  });
}
