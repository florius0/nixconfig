{ pkgs, ... }:

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
    iterm2
    jdk21
    jira-cli-go
    lazygit
    pandoc
    postgresql
    postman
    websocat

    # Communication Tools
    discord
    slack

    # Browsers
    google-chrome

    # Entertainment Tools
    iina

    # Programming languages and tooling
    bun
    delve
    dotnet-sdk
    elixir
    erlang
    go
    livebook
    nixfmt-rfc-style
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

    # Media-related packages
    dejavu_fonts
    exiftool
    fd
    ffmpeg_6
    font-awesome
    hack-font
    imagemagick
    meslo-lgs-nf
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-emoji

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
    speedtest-cli
    tmux
    tree
    unrar
    unzip
    vitetris
    wget
    yq-go
  ];
}
