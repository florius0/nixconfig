{ config, pkgs, ... }:

let
  port = 18765;
  stateDir = "${config.xdg.stateHome}/plantuml-server";
  server = pkgs.writeShellScript "plantuml-server" ''
    set -eu

    state_dir="${stateDir}"
    webapps="$state_dir/webapps"
    mkdir -p "$webapps"
    ln -sf "${pkgs.plantuml-server}/webapps/plantuml.war" "$webapps/plantuml.war"

    if [ ! -f "$state_dir/start.d/ee11-jsp.ini" ]; then
      cd "$state_dir"
      ${pkgs.jre}/bin/java -jar ${pkgs.jetty}/start.jar --add-modules=server,http,ee11-deploy,ee11-annotations,ee11-jsp,ee11-jstl
    fi

    cd "$state_dir"
    exec ${pkgs.jre}/bin/java -jar ${pkgs.jetty}/start.jar jetty.http.port=${toString port}
  '';
in
{
  launchd.agents.plantuml-server = {
    enable = true;
    config = {
      ProgramArguments = [ "${server}" ];
      KeepAlive = true;
      ProcessType = "Background";
      EnvironmentVariables = {
        GRAPHVIZ_DOT = "${pkgs.graphviz}/bin/dot";
      };
      StandardOutPath = "${stateDir}/stdout.log";
      StandardErrorPath = "${stateDir}/stderr.log";
    };
  };
}
