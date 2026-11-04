final: prev: {
  chatgpt = prev.chatgpt.overrideAttrs (_: {
    version = "26.1027.61615";
    src = final.fetchurl {
      url = "https://persistent.oaistatic.com/codex-app-prod/ChatGPT-darwin-arm64-26.1027.61615.zip";
      hash = "sha256-oi6B/55S5/MAbGV/8gBsA0mCh2paigArv5wA+/gwfyM=";
    };
  });
}
