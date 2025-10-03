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
      postFixup = (prevAttrs.postFixup or "") + ''
        set -euo pipefail
        app="$out/Applications/IINA.app"
        fw="$app/Contents/Frameworks"

        # swap libmpv
        rm -f "$fw"/libmpv.* || true
        ln -s ${final.mpv-vs}/lib/libmpv.2.dylib "$fw/libmpv.2.dylib"
        install_name_tool -id "@rpath/libmpv.2.dylib" "$fw/libmpv.2.dylib" || true

        # bundle libvapoursynth for lazy dlopen()
        if [ -e ${final.vapoursynth}/lib/libvapoursynth.dylib ]; then
          cp -f ${final.vapoursynth}/lib/libvapoursynth.dylib "$fw/libvapoursynth.dylib"
          install_name_tool -id "@rpath/libvapoursynth.dylib" "$fw/libvapoursynth.dylib" || true
        fi

        # rewrite any /nix/store deps to @rpath/<name> so they resolve in IINA's Frameworks
        while IFS= read -r dep; do
          base="$(basename "$dep")"
          if [ -e "$fw/$base" ]; then
            install_name_tool -change "$dep" "@rpath/$base" "$fw/libmpv.2.dylib" || true
          fi
        done < <(otool -L "$fw/libmpv.2.dylib" | awk '/^\t\/nix\/store\//{print $1}')
      '';

    }
  );
}
