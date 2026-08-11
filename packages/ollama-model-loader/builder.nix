{
  lib,
  pkgs,
  package,
  acceleration,
  host,
  port,
  loadModels,
  cleanup,
}:

# Builds the launchd-run model loader script: pulls declared upstream models,
# derives Modelfile-based ones, and (with cleanup = "uninstall") removes
# undeclared models. Not autowired: args are config-shaped and only make
# sense supplied by the `services.ollama` home-manager module.
let
  inherit (lib)
    concatStringsSep
    escapeShellArg
    getExe
    mapAttrsToList
    optionalString
    ;

  ollamaPackage = if acceleration == null then package else package.override { inherit acceleration; };

  renderScalar =
    value:
    if builtins.isString value then
      builtins.toJSON value
    else if builtins.isBool value then
      (if value then "true" else "false")
    else
      toString value;

  renderParameter =
    name: value:
    let
      values = if builtins.isList value then value else [ value ];
    in
    concatStringsSep "\n" (map (item: "PARAMETER ${name} ${renderScalar item}") values);

  renderMultiline = keyword: value: ''
    ${keyword} """
    ${value}
    """
  '';

  normalizedModels = mapAttrsToList (
    finalName: model:
    let
      sourceName = if model.from == null then finalName else model.from;
      isDerived =
        model.from != null
        || model.parameters != { }
        || model.system != null
        || model.template != null
        || model.requires != null
        || model.modelfile != null;
      modelfile =
        pkgs.writeText "ollama-${builtins.replaceStrings [ ":" "/" ] [ "-" "-" ] finalName}.Modelfile"
          (
            concatStringsSep "\n" (
              [ "FROM ${sourceName}" ]
              ++ mapAttrsToList renderParameter model.parameters
              ++ lib.optional (model.system != null) (renderMultiline "SYSTEM" model.system)
              ++ lib.optional (model.template != null) (renderMultiline "TEMPLATE" model.template)
              ++ lib.optional (model.requires != null) "REQUIRES ${model.requires}"
              ++ lib.optional (model.modelfile != null) model.modelfile
            )
            + "\n"
          );
    in
    {
      inherit
        finalName
        sourceName
        isDerived
        modelfile
        ;
    }
  ) loadModels;

  sourcesToPull = lib.unique (map (model: model.sourceName) normalizedModels);
  derivedModels = builtins.filter (model: model.isDerived) normalizedModels;
  declaredModels = pkgs.writeText "ollama-declared-models" (
    concatStringsSep "\n" (map (model: model.finalName) normalizedModels) + "\n"
  );
in
pkgs.writeShellScript "ollama-model-loader" ''
  set -eu

  OLLAMA="${getExe ollamaPackage}"
  OLLAMA_API="http://${host}:${toString port}"

  attempt=0
  until ${pkgs.curl}/bin/curl -fsS --max-time 2 "$OLLAMA_API/api/tags" >/dev/null; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge 60 ]; then
      echo "Ollama did not become reachable at $OLLAMA_API" >&2
      exit 1
    fi
    /bin/sleep 2
  done

  ${concatStringsSep "\n" (
    map (source: "${escapeShellArg (getExe ollamaPackage)} pull ${escapeShellArg source}") sourcesToPull
  )}

  ${concatStringsSep "\n" (
    map (
      model:
      "${escapeShellArg (getExe ollamaPackage)} create ${escapeShellArg model.finalName} -f ${escapeShellArg model.modelfile}"
    ) derivedModels
  )}

  ${optionalString (cleanup == "uninstall") ''
    is_declared() {
      while IFS= read -r declared; do
        [ "$1" = "$declared" ] && return 0
        case "$declared" in
          *:*) ;;
          *) [ "$1" = "$declared:latest" ] && return 0 ;;
        esac
      done < ${escapeShellArg declaredModels}
      return 1
    }

    model_list="$(${getExe ollamaPackage} list)" || exit 1
    while IFS= read -r model; do
      [ -n "$model" ] || continue
      if ! is_declared "$model"; then
        ${getExe ollamaPackage} rm "$model"
      fi
    done < <(printf '%s\n' "$model_list" | tail -n +2 | awk '{print $1}')
  ''}
''
