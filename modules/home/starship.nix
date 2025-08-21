{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      format = "$os$directory$git_branch$git_commit$git_status$character";
      right_format = "$status$time$cmd_duration$jobs$aws$kubernetes$terraform$nix_shell$python$nodejs$rust$golang$php$dotnet$ruby$java$lua$perl$elixir$haskell$julia$swift$dart$scala$erlang$nim$deno";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      os = {
        format = "[$symbol]($style)";
        style = "bold white";
        disabled = false;
        symbols = {
          Macos = " ";
          Ubuntu = " ";
          Debian = " ";
          Arch = " ";
          Fedora = " ";
          Windows = " ";
        };
      };

      directory = {
        format = "[$read_only]($read_only_style)[$path]($style) ";
        style = "bold blue";
        truncation_length = 3;
        fish_style_pwd_dir_length = 3;
        truncate_to_repo = false;
        read_only = " ";
        home_symbol = "~";
      };

      git_branch = {
        format = "([ ](bold green)[ $branch]($style)) ";
        style = "bold purple";
      };

      git_commit = {
        format = "[$hash$tag]($style) ";
        tag_disabled = false;
      };

      git_status = {
        format = "$all_status$ahead_behind";
        ahead = "[⇡\${count}](green) ";
        behind = "[⇣\${count}](green) ";
        conflicted = "[!\${count}](red) ";
        deleted = "[✘\${count}](red) ";
        diverged = "[⇡\${ahead_count}⇣\${behind_count}](green) ";
        modified = "[!\${count}](yellow) ";
        renamed = "[»\${count}](yellow) ";
        staged = "[+\${count}](yellow) ";
        stashed = "[*\${count}](green) ";
        untracked = "[?\${count}](blue) ";
        up_to_date = "[\${count}](blue) ";
        style = "bold yellow";
        ignore_submodules = false;
        disabled = false;
      };

      cmd_duration = {
        format = "[ $duration]($style) ";
        style = "bold cyan";
        min_time = 1000;
      };

      jobs = {
        format = "[$number]($style) ";
        style = "bold red";
        threshold = 1;
      };

      status = {
        format = "[$status]($style) ";
        style = "bold red";
        disabled = false;
      };

      time = {
        format = "[ $time]($style) ";
        style = "bold white";
        disabled = false;
      };

      aws = {
        format = "[ $profile]($style) ";
        style = "bold orange";
        disabled = false;
      };

      kubernetes = {
        format = "[󱃾 $context]($style) ";
        style = "bold blue";
        disabled = false;
      };

      terraform = {
        format = "[󱁢 $workspace]($style) ";
        style = "bold green";
        disabled = false;
      };

      nix_shell = {
        format = "[ $state]($style) ";
        style = "bold blue";
        disabled = false;
      };

      # Programming Languages and Tools
      python = {
        format = "[ $version]($style) ";
        style = "bold yellow";
        disabled = false;
      };
      nodejs = {
        format = "[ $version]($style) ";
        style = "bold green";
        disabled = false;
      };
      rust = {
        format = "[ $version]($style) ";
        style = "bold red";
        disabled = false;
      };
      golang = {
        format = "[ $version]($style) ";
        style = "bold cyan";
        disabled = false;
      };
      php = {
        format = "[ $version]($style) ";
        style = "bold blue";
        disabled = false;
      };
      dotnet = {
        format = "[ $version]($style) ";
        style = "bold purple";
        disabled = false;
      };
      ruby = {
        format = "[ $version]($style) ";
        style = "bold red";
        disabled = false;
      };
      java = {
        format = "[ $version]($style) ";
        style = "bold blue";
        disabled = false;
      };
      lua = {
        format = "[ $version]($style) ";
        style = "bold cyan";
        disabled = false;
      };
      perl = {
        format = "[ $version]($style) ";
        style = "bold green";
        disabled = false;
      };
      elixir = {
        format = "[ $version]($style) ";
        style = "bold purple";
        disabled = false;
      };
      haskell = {
        format = "[ $version]($style) ";
        style = "bold magenta";
        disabled = false;
      };
      julia = {
        format = "[ $version]($style) ";
        style = "bold green";
        disabled = false;
      };
      swift = {
        format = "[ $version]($style) ";
        style = "bold orange";
        disabled = false;
      };
      dart = {
        format = "[ $version]($style) ";
        style = "bold blue";
        disabled = false;
      };
      scala = {
        format = "[ $version]($style) ";
        style = "bold red";
        disabled = false;
      };
      erlang = {
        format = "[ $version]($style) ";
        style = "bold dark_red";
        disabled = false;
      };
      nim = {
        format = "[ $version]($style) ";
        style = "bold yellow";
        disabled = false;
      };
      deno = {
        format = "[ $version]($style) ";
        style = "bold green";
        disabled = false;
      };
    };
  };
}
