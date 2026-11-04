final: prev: {
  solidcraft = final.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "solidcraft";
    version = "0.30.1";

    src = final.fetchurl {
      url = "https://github.com/tangency-labs/solidcraft/releases/download/v${finalAttrs.version}/solidcraft-${finalAttrs.version}-macos-universal.dmg";
      hash = "sha256-3PVrgKrKYZW1hU+QA/VkhYDRk13HdABg4ra4hb4gCi0=";
    };

    nativeBuildInputs = [ final.undmg ];
    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    # Preserve the upstream app bundle's code signature.
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications" "$out/bin"
      cp -R SolidCraft.app "$out/Applications/"
      ln -s "$out/Applications/SolidCraft.app/Contents/MacOS/solidcraft-cli" \
        "$out/bin/solidcraft-cli"
      runHook postInstall
    '';

    meta = {
      description = "Parametric 3D CAD app with a bundled command-line interface";
      homepage = "https://solidcraft.io/";
      license = with final.lib.licenses; [
        mit
        asl20
      ];
      mainProgram = "solidcraft-cli";
      platforms = final.lib.platforms.darwin;
      sourceProvenance = [ final.lib.sourceTypes.binaryNativeCode ];
    };
  });
}
