final: prev:
let
  version = "0.32.5";
  darwinOllama = prev.fetchurl {
    url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-darwin.tgz";
    hash = "sha256-V4ndA3qGrbMoxywR/EXmxVhFLQfltQgUqL23sPvbzYE=";
  };
in
if prev.stdenv.hostPlatform.system == "aarch64-darwin" then
  {
    ollama = prev.ollama.overrideAttrs (old: {
      inherit version;
      src = darwinOllama;

      pname = "ollama";
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      dontFixup = true;
      nativeBuildInputs = [ final.gnutar ];
      phases = [ "installPhase" ];
      preInstall = "";
      postInstall = "";

      installPhase = ''
        unpacked=$(mktemp -d)
        tar -xzf "$src" -C "$unpacked"
        mkdir -p "$out/bin" "$out/lib/ollama"

        if [ -f "$unpacked/ollama" ]; then
          mv "$unpacked/ollama" "$out/bin/ollama"
        elif [ -f "$unpacked/bin/ollama" ]; then
          mv "$unpacked/bin/ollama" "$out/bin/ollama"
        else
          echo "The Ollama Darwin archive does not contain an ollama binary" >&2
          exit 1
        fi

        if [ -d "$unpacked/lib/ollama" ]; then
          cp -a "$unpacked/lib/ollama/." "$out/lib/ollama/"
        elif [ -d "$unpacked/ollama" ]; then
          cp -a "$unpacked/ollama/." "$out/lib/ollama/"
        fi

        for runtime in \
          "$unpacked/llama-server" \
          "$unpacked/llama-quantize" \
          "$unpacked"/*.so \
          "$unpacked"/*.dylib \
          "$unpacked"/*.metallib \
          "$unpacked"/mlx_metal_v*; do
          [ -e "$runtime" ] || continue
          cp -a "$runtime" "$out/lib/ollama/"
        done

      '';

      meta = old.meta // {
        description = "Get up and running with large language models";
        homepage = "https://ollama.com";
        sourceProvenance = [ final.lib.sourceTypes.binaryNativeCode ];
        platforms = [ "aarch64-darwin" ];
      };
    });
  }
else
  {
  }
