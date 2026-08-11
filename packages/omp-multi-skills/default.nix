{
  stdenvNoCC,
  bun,
}:

stdenvNoCC.mkDerivation {
  pname = "omp-multi-skills";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ bun ];

  dontBuild = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    HOME="$TMPDIR" bun test parser.test.ts
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp index.ts parser.ts "$out/"
    runHook postInstall
  '';
}
