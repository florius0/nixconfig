final: prev: {
  leaf = final.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "leaf";
    version = "0.15.2";

    src = final.fetchurl {
      url = "https://github.com/DeepanshuMishraa/leaf/releases/download/v${finalAttrs.version}/leaf-aarch64-apple-darwin.tar.gz";
      hash = "sha256-3xE4QCWyVPwnDKMTSJRr2hxdryIKQm3ODjE2wdFJ7i4=";
    };

    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    # Preserve the upstream binary's code signature.
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 leaf "$out/bin/leaf"
      install -Dm644 LICENSE "$out/share/licenses/leaf/LICENSE"
      runHook postInstall
    '';

    meta = {
      description = "Read PDFs, Markdown files and web articles in the terminal, and review diffs";
      homepage = "https://github.com/DeepanshuMishraa/leaf";
      license = final.lib.licenses.mit;
      mainProgram = "leaf";
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = [ final.lib.sourceTypes.binaryNativeCode ];
    };
  });
}
