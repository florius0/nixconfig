final: prev: {
  mpv-vs = prev.mpv-unwrapped.overrideAttrs (old: {
    pname = "mpv-vs";
    buildInputs = (old.buildInputs or [ ]) ++ [ final.vapoursynth ];
    configureFlags = (old.configureFlags or [ ]) ++ [
      "--enable-vapoursynth"
      "--enable-vulkan"
    ];
  });

  iina-mpv-vs = prev.iina.overrideAttrs (
    finalAttrs: prevAttrs: {
      pname = "iina-mpv-vs";

      buildInputs = (prevAttrs.buildInputs or [ ]) ++ [
        final.mpv-vs
        final.vapoursynth
      ];

      nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [
        prev.stdenv.cc
        prev.buildPackages.darwin.cctools # for install_name_tool
      ];

      postFixup = (prevAttrs.postFixup or "") + ''
        set -euo pipefail
        app="$out/Applications/IINA.app"
        macos="$app/Contents/MacOS"
        fw="$app/Contents/Frameworks"
        res="$app/Contents/Resources"

        # --- swap in our libmpv (COPY, not symlink) ---
        rm -f "$fw"/libmpv.* || true
        cp ${final.mpv-vs}/lib/libmpv.2.dylib "$fw/libmpv.2.dylib"
        chmod +w "$fw/libmpv.2.dylib"
        install_name_tool -id "@rpath/libmpv.2.dylib" "$fw/libmpv.2.dylib" || true

        # --- bundle VapourSynth dylibs ---
        for lib in libvapoursynth.dylib libvapoursynth-script.0.dylib; do
          if [ -e ${final.vapoursynth}/lib/$lib ]; then
            cp -f ${final.vapoursynth}/lib/$lib "$fw/$lib"
            chmod +w "$fw/$lib"
            install_name_tool -id "@rpath/$lib" "$fw/$lib" || true
          fi
        done

        # --- bundle the Python extension module ---
        mkdir -p "$res/python"
        cp -f ${final.vapoursynth}/lib/python*/site-packages/vapoursynth.* "$res/python/"

        # --- OPTIONAL: rewrite any /nix/store deps in libmpv to @rpath/<name> ---
        while IFS= read -r dep; do
          base="$(basename "$dep")"
          if [ -e "$fw/$base" ]; then
            install_name_tool -change "$dep" "@rpath/$base" "$fw/libmpv.2.dylib" || true
          fi
        done < <(otool -L "$fw/libmpv.2.dylib" | awk '/^\t\/nix\/store\//{print $1}')

        # --- replace the app's entrypoint with a tiny C wrapper (Mach-O) ---
        mv "$macos/IINA" "$macos/IINA.real"

        cat > "$TMPDIR/iina-wrapper.c" <<'EOF'
        #include <mach-o/dyld.h>
        #include <libgen.h>
        #include <limits.h>
        #include <stdlib.h>
        #include <unistd.h>
        #include <string.h>
        #include <stdio.h>
        int main(int argc, char **argv) {
            char execPath[PATH_MAX]; uint32_t sz = sizeof(execPath);
            if (_NSGetExecutablePath(execPath, &sz) != 0) return 1;
            char realExec[PATH_MAX];
            if (!realpath(execPath, realExec)) strncpy(realExec, execPath, sizeof(realExec));
            char *dir = dirname(realExec); // .../Contents/MacOS
            char contents[PATH_MAX]; snprintf(contents, sizeof(contents), "%s/..", dir);

            char py[PATH_MAX]; snprintf(py, sizeof(py), "%s/Resources/python", contents);
            setenv("PYTHONPATH", py, 1);

            char vsl[PATH_MAX]; snprintf(vsl, sizeof(vsl), "%s/Frameworks/libvapoursynth-script.0.dylib", contents);
            setenv("VAPOURSYNTH_LIBRARY", vsl, 1);

            // Optional: make our Frameworks preferred for dlopen() lookups.
            char dyldfb[PATH_MAX]; snprintf(dyldfb, sizeof(dyldfb), "%s/Frameworks", contents);
            setenv("DYLD_FALLBACK_LIBRARY_PATH", dyldfb, 1);

            char realbin[PATH_MAX]; snprintf(realbin, sizeof(realbin), "%s/MacOS/IINA.real", contents);
            execv(realbin, argv);
            return 1;
        }
        EOF

        cc -O2 -std=c11 "$TMPDIR/iina-wrapper.c" -o "$macos/IINA"
        chmod +x "$macos/IINA"
      '';
    }
  );
}
