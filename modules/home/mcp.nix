{
  flake,
  lib,
  pkgs,
  ...
}:

let
  mcpServers = {
    atuin = {
      command = "atuin";
      args = [ "mcp" ];
    };
  };

  codexMcpConfig = (pkgs.formats.toml { }).generate "codex-mcp-config" {
    mcp_servers = mcpServers;
  };

  claudeMcpConfig = (pkgs.formats.json { }).generate "claude-mcp-config" {
    mcpServers = lib.mapAttrs (_: server: server // { type = "stdio"; }) mcpServers;
  };
in
{
  home.activation.configureWritableMcp = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    codex_config="$HOME/.codex/config.toml"
    if [ -L "$codex_config" ]; then
      rm "$codex_config"
    fi
    if [ ! -e "$codex_config" ]; then
      install -Dm644 ${codexMcpConfig} "$codex_config"
    fi

    claude_config="$HOME/.claude.json"
    claude_tmp="$(mktemp "$HOME/.claude.json.XXXXXX")"
    if [ -e "$claude_config" ]; then
      ${pkgs.jq}/bin/jq --slurpfile mcp ${claudeMcpConfig} \
        '.mcpServers = ((.mcpServers // {}) * $mcp[0].mcpServers)' \
        "$claude_config" > "$claude_tmp"
    else
      cat ${claudeMcpConfig} > "$claude_tmp"
    fi
    if [ -L "$claude_config" ]; then
      rm "$claude_config"
    fi
    install -m644 "$claude_tmp" "$claude_config"
    rm -f "$claude_tmp"
  '';

  programs.mcp = {
    enable = true;
    servers.atuin = {
      command = "atuin";
      args = [ "mcp" ];
    };
  };

  programs.codex = {
    enable = true;
    package = flake.inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
    enableMcpIntegration = false;
  };

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = false;
  };

  # OMP's native user-level MCP configuration.
  home.file.".omp/agent/mcp.json".text = builtins.toJSON {
    "$schema" =
      "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json";
    mcpServers = mcpServers;
  };
}
