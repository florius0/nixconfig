# overlays/iina-vs.nix
final: prev: {
  # mpv with VapourSynth enabled — we only need libmpv from this
  mpv-vs = prev.mpv-unwrapped.override {
    vapoursynthSupport = true;
    vulkanSupport = true; # if your nixpkgs supports it on darwin
  };

  # New package name so you can't accidentally pull stock iina
  iina-mpv-vs = prev.iina.overrideAttrs (
    finalAttrs: prevAttrs: {
      pname = "iina-mvp-vs";
      buildInputs = (prevAttrs.buildInputs or [ ]) ++ [
        final.mpv-vs
        final.vapoursynth
      ];

      # Do the swap inside the derivation so it’s reproducible
      postInstall = (prevAttrs.postInstall or "") + ''
        set -euo pipefail
        app="$out/Applications/IINA.app"
        fw="$app/Contents/Frameworks"

        echo ">>> iina-vs: replacing bundled libmpv with Nix libmpv (vapoursynth)"
        rm -f "$fw"/libmpv.* || true
        ln -s ${final.mpv-vs}/lib/libmpv.2.dylib "$fw/libmpv.2.dylib"

        # Bundle libvapoursynth so dlopen works at runtime
        if [ -e ${final.vapoursynth}/lib/libvapoursynth.dylib ]; then
          cp -f ${final.vapoursynth}/lib/libvapoursynth.dylib "$fw/libvapoursynth.dylib"
        fi

        echo ">>> iina-vs: Frameworks contents"
        /usr/bin/ls -l "$fw" | /usr/bin/sed -n '1,200p'
      '';
    }
  );
}
