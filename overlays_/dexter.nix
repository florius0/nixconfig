final: prev: {
  dexter = final.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "dexter";
    version = "0.7.2";

    src = final.fetchurl {
      url = "https://github.com/remoteoss/dexter/releases/download/v${finalAttrs.version}/dexter_Darwin_arm64.tar.gz";
      hash = "sha256-XQco4fn2E1i5uH/LXcT+oNuAUj5Tn0owEITuk2GVyHw=";
    };

    nativeBuildInputs = [ final.makeWrapper ];

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 dexter "$out/bin/dexter"
      wrapProgram "$out/bin/dexter" \
        --prefix PATH : ${
          final.lib.makeBinPath [
            final.beamPackages.elixir
            final.beamPackages.erlang
          ]
        }
      runHook postInstall
    '';

    meta = {
      description = "Elixir language server optimized for large codebases";
      homepage = "https://github.com/remoteoss/dexter";
      license = final.lib.licenses.mit;
      mainProgram = "dexter";
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = [ final.lib.sourceTypes.binaryNativeCode ];
    };
  });
}
