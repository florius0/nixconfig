{ flake, pkgs, ... }:

{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # General packages for development and system management
    appcleaner
    automake
    cmake
    gh
    git-filter-repo
    git-lfs
    git-worktree-switcher
    glow
    grpcurl
    jira-cli-go
    lazygit
    pandoc
    postgresql
    postman
    websocat

    # Browsers
    google-chrome

    # Entertainment Tools
    iina
    ckan

    # Programming languages and tooling
    bun
    delve
    dotnet-sdk
    beamPackages.elixir
    beamPackages.erlang
    go
    livebook
    nixfmt
    nodejs
    (python3.withPackages (ps: [
      ps.pip
      ps.pyaml
      ps.atlassian-python-api
      ps.requests
      ps.playwright
    ]))
    playwright-driver.browsers
    shfmt
    tinymist
    typst
    virtualenv

    # Editors
    nano
    vim
    neovim

    # Encryption and security tools
    age
    age-plugin-yubikey
    gnupg
    libfido2

    # Cloud-related tools and SDKs
    awscli2
    docker
    doctl
    kubecolor
    kubectl
    lens
    werf

    # 3D & Media tools
    exiftool
    ffmpeg
    imagemagick

    # Other media packages
    dejavu_fonts
    font-awesome
    hack-font
    meslo-lgs-nf
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-color-emoji

    # AI
    chatgpt
    claude-code
    codex
    flake.inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.omp
    ollama
    pi-coding-agent

    # Text and terminal utilities
    bash
    bat
    cloc
    curl
    eza
    fastfetch
    fd
    fzf
    graphviz
    htop
    httpie
    hunspell
    iftop
    jq
    lf
    parallel
    ripgrep
    smartmontools
    speedtest-cli
    tmux
    tree
    unrar
    unzip
    wget
    yq-go
  ];
}
