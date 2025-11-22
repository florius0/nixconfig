{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          publisher = "42crunch";
          name = "vscode-openapi";
          version = "4.31.0";
          sha256 = "sha256-ZS47eAKQBHB2ijNlMu1sVN/3U3vT7E7AMdC/9HN4uCg=";
        }
        {
          publisher = "alanrynne";
          name = "ifc-syntax";
          version = "0.2.7";
          sha256 = "sha256-Ha2Fq5oJnUf2ibAwB11j92yog2f/4D1e4x0W8gt1pjE=";
        }
        {
          publisher = "animallogic";
          name = "vscode-usda-syntax";
          version = "0.2.0";
          sha256 = "sha256-lxx5NyIxxSowqK5Dmg4ABxyKkjBzSNlNE+K59NHoLag=";
        }
        {
          publisher = "atlassian";
          name = "atlascode";
          version = "3.4.11";
          sha256 = "sha256-w7ej+FpXFfDi2SC4L7+egxmpJZ7M5ap/FBLW8brRJ/M=";
        }
        {
          publisher = "attilabuti";
          name = "vscode-mjml";
          version = "1.6.0";
          sha256 = "sha256-zZ+SbhNTzVxdECXbicVxVmLPlqHuTmzFq6UDeoLfGaA=";
        }
        {
          publisher = "bbenoist";
          name = "nix";
          version = "1.0.1";
          sha256 = "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=";
        }
        {
          publisher = "benvp";
          name = "vscode-hex-pm-intellisense";
          version = "0.5.0";
          sha256 = "sha256-KzDy9YaS0iXlYJdK1HFQNQTXT/EOjqwhE+21cA9Hr0k=";
        }
        {
          publisher = "bierner";
          name = "docs-view";
          version = "0.1.0";
          sha256 = "sha256-Y5bQVb0OuhHvpvZPXlJRe17qSN3tzqm8JwS6nO2tG7g=";
        }
        {
          publisher = "cesium";
          name = "gltf-vscode";
          version = "2.5.1";
          sha256 = "sha256-EFgYQO3Eu68VynkObLeNcHtHizF5il5qLE3drbatwyQ=";
        }
        {
          publisher = "christian-kohler";
          name = "npm-intellisense";
          version = "1.4.5";
          sha256 = "sha256-liuFGnyvvVHzSv60oLkemFyv85R+RiGKErRIUz2PYKs=";
        }
        {
          publisher = "christian-kohler";
          name = "path-intellisense";
          version = "2.10.0";
          sha256 = "sha256-bE32VmzZBsAqgSxdQAK9OoTcTgutGEtgvw6+RaieqRs=";
        }
        {
          publisher = "cschlosser";
          name = "doxdocgen";
          version = "1.4.0";
          sha256 = "sha256-InEfF1X7AgtsV47h8WWq5DZh6k/wxYhl2r/pLZz9JbU=";
        }
        {
          publisher = "dart-code";
          name = "dart-code";
          version = "3.104.0";
          sha256 = "sha256-y09lVr2M2Nfvs/Onm7fvDXvwmqbcXWnKkANKk2r2XEI=";
        }
        {
          publisher = "davidanson";
          name = "vscode-markdownlint";
          version = "0.59.0";
          sha256 = "sha256-zbK7kRa9k5xIM7BcwMOT1pRO7637eMUCUzgQwnpBCvI=";
        }
        {
          publisher = "davidbwaters";
          name = "macos-modern-theme";
          version = "2.3.19";
          sha256 = "sha256-/gpGu3vvomQA0TC+TBJkBe2AFWimIyiMM5fndYF8G/A=";
        }
        {
          publisher = "deerawan";
          name = "vscode-dash";
          version = "2.4.0";
          sha256 = "sha256-Yqn59ppNWQRMWGYVLLWofogds+4t/WRRtSSfomPWQy4=";
        }
        {
          publisher = "denco";
          name = "confluence-markup";
          version = "1.0.4";
          sha256 = "sha256-3XpSMMi2ZawgFIvTBbMH9Mxma2TKCk9fNgftYuW9M8Y=";
        }
        {
          publisher = "dotjoshjohnson";
          name = "xml";
          version = "2.5.1";
          sha256 = "sha256-ZwBNvbld8P1mLcKS7iHDqzxc8T6P1C+JQy54+6E3new=";
        }
        {
          publisher = "eamodio";
          name = "gitlens";
          version = "16.3.2";
          sha256 = "sha256-+TYE2kwgSTYtg8V8M7VSxpxsm6agj8sFun79wIMT5gs=";
        }
        {
          publisher = "earthly";
          name = "earthfile-syntax-highlighting";
          version = "0.0.16";
          sha256 = "sha256-xU1v1NL1A6EDG+kv8Ri16xuZeQdRFzTnMOCLGpCmlg8=";
        }
        {
          publisher = "efanzh";
          name = "graphviz-preview";
          version = "1.7.4";
          sha256 = "sha256-9wgnm/KHXWcFaibuzdxZHRJ0MAbIWQYGe6plJgKP21M=";
        }
        {
          publisher = "foxundermoon";
          name = "shell-format";
          version = "7.2.5";
          sha256 = "sha256-kfpRByJDcGY3W9+ELBzDOUMl06D/vyPlN//wPgQhByk=";
        }
        {
          publisher = "github";
          name = "remotehub";
          version = "0.64.0";
          sha256 = "sha256-Nh4PxYVdgdDb8iwHHUbXwJ5ZbMruFB6juL4Yg/wdKMY=";
        }
        {
          publisher = "github";
          name = "vscode-github-actions";
          version = "0.27.1";
          sha256 = "sha256-mHKaWXSyDmsdQVzMqJI6ctNUwE/6bs1ZyeAEWKg9CV8=";
        }
        {
          publisher = "github";
          name = "vscode-pull-request-github";
          version = "0.98.0";
          sha256 = "sha256-oOnojfVPB5XdEQbmmmeFQrZEGW41ZtotJRYKVbiehBM=";
        }
        {
          publisher = "golang";
          name = "go";
          version = "0.46.1";
          sha256 = "sha256-R5SC6vMWT3alunlklJKcEKKJhNd6GI2MF9/QWwuNprs=";
        }
        {
          publisher = "gruntfuggly";
          name = "align-mode";
          version = "0.0.21";
          sha256 = "sha256-/v2C6sDEpzcw7EkrdtLoiO6y8cS48P/4sbzmf76kGtM=";
        }
        {
          publisher = "gruntfuggly";
          name = "todo-tree";
          version = "0.0.226";
          sha256 = "sha256-Fj9cw+VJ2jkTGUclB1TLvURhzQsaryFQs/+f2RZOLHs=";
        }
        {
          publisher = "haskell";
          name = "haskell";
          version = "2.4.4";
          sha256 = "sha256-O7tfZ1bQmlMgZGoWuECjSno6DLCO0+CCteRhT6PjZBY=";
        }
        {
          publisher = "hediet";
          name = "vscode-drawio";
          version = "1.6.6";
          sha256 = "sha256-SPcSnS7LnRL5gdiJIVsFaN7eccrUHSj9uQYIQZllm0M=";
        }
        {
          publisher = "ipedrazas";
          name = "kubernetes-snippets";
          version = "0.1.9";
          sha256 = "sha256-BlPEzRSe2NfRPjyShepa2DEhe1Jgiq7bXk2ze3eqwT0=";
        }
        {
          publisher = "james-yu";
          name = "latex-workshop";
          version = "10.7.4";
          sha256 = "sha256-9swXb/c2XH9lbSgCP+8MD9BN7/dKDJVtEA+YMLtRPZo=";
        }
        {
          publisher = "jebbs";
          name = "plantuml";
          version = "2.18.1";
          sha256 = "sha256-o4FN/vUEK53ZLz5vAniUcnKDjWaKKH0oPZMbXVarDng=";
        }
        {
          publisher = "jeff-hykin";
          name = "better-cpp-syntax";
          version = "1.27.1";
          sha256 = "sha256-GO/ooq50KLFsiEuimqTbD/mauQYcD/p2keHYo/6L9gw=";
        }
        {
          publisher = "jnoortheen";
          name = "nix-ide";
          version = "0.4.16";
          sha256 = "sha256-MdFDOg9uTUzYtRW2Kk4L8V3T/87MRDy1HyXY9ikqDFY=";
        }
        {
          publisher = "josephwoodward";
          name = "vscodeilviewer";
          version = "0.0.1";
          sha256 = "sha256-PI6YFSFM+h8eu9YCXRUUSnwgeCsMKEILMjBNZLz9FR4=";
        }
        {
          publisher = "justusadam";
          name = "language-haskell";
          version = "3.6.0";
          sha256 = "sha256-rZXRzPmu7IYmyRWANtpJp3wp0r/RwB7eGHEJa7hBvoQ=";
        }
        {
          publisher = "kabie";
          name = "elixir-zigler";
          version = "0.1.0";
          sha256 = "sha256-ELmxthy6rO1IVmTQitbzh7M6e3EZr9CWhqkTF4UREh0=";
        }
        {
          publisher = "lexical-lsp";
          name = "lexical";
          version = "0.0.24";
          sha256 = "sha256-aAGReiVKkrTlQWyRpYIlBTRnn3Py38chHvCMmqTBtu0=";
        }
        {
          publisher = "lunuan";
          name = "kubernetes-templates";
          version = "1.3.1";
          sha256 = "sha256-1XS28VLbdSQjAAnCrvid/aE8GA2WReB9Roa6E3PqXi4=";
        }
        {
          publisher = "mateocerquetella";
          name = "xcode-12-theme";
          version = "5.0.0";
          sha256 = "sha256-rMVpn8bu2KTLyjEQIHYlwTDSCvMdMtM7J9EApXd9EBg=";
        }
        {
          publisher = "mattfoulks";
          name = "har-analyzer";
          version = "0.0.11";
          sha256 = "sha256-JSkIYJcH0wPEPhqZOiDCGhocDe5Eubj1MocjJKS3qCE=";
        }
        {
          publisher = "meezilla";
          name = "json";
          version = "0.1.2";
          sha256 = "sha256-p3/3cfXIMeQVZ5zsWV3iAaZhIfXE2mR79IyV0f79hMQ=";
        }
        {
          publisher = "mrorz";
          name = "language-gettext";
          version = "0.5.0";
          sha256 = "sha256-1hdT2Fai0o48ojNqsjW+McokD9Nzt2By3vzhGUtgaeA=";
        }
        {
          publisher = "myriad-dreamin";
          name = "tinymist";
          version = "0.13.12";
          sha256 = "sha256-1mBzimFM/ntjL/d0YkoCds5MtXKwB52jzcHEWpx3Ggo=";
        }
        {
          publisher = "ms-azuretools";
          name = "vscode-docker";
          version = "1.29.4";
          sha256 = "sha256-j2ACz2Ww5hddoDLHGdxnuQIqerP5ogZ80/wS+Aa5Gdo=";
        }
        {
          publisher = "ms-dotnettools";
          name = "csdevkit";
          version = "1.16.6";
          sha256 = "sha256-ahRWBzjk/Wt36PqhSuHvi1UIOliWTbjSCoXVIpnY++4=";
        }
        {
          publisher = "ms-dotnettools";
          name = "csharp";
          version = "2.63.32";
          sha256 = "sha256-M2k8mzH8XXnKVdAHkhwYigUclOcAJ/UnqBoWX8fwzxo=";
        }
        {
          publisher = "ms-dotnettools";
          name = "vscode-dotnet-runtime";
          version = "2.2.8";
          sha256 = "sha256-1dwkkaGQC5CZjOmebzSSqkomhA0hOXiIv8jV+Vo8jcw=";
        }
        {
          publisher = "ms-dotnettools";
          name = "vscodeintellicode-csharp";
          version = "2.2.3";
          sha256 = "sha256-E2KRzjIxLFmwArzEKittjejacrCOFFNNzphWw8v5CpE=";
        }
        {
          publisher = "ms-kubernetes-tools";
          name = "vscode-kubernetes-tools";
          version = "1.3.18";
          sha256 = "sha256-umVWpfhXW00R0ZNRkzFler68ZK5GXMEZUnJ2DcC+Cxk=";
        }
        {
          publisher = "ms-python";
          name = "autopep8";
          version = "2024.2.0";
          sha256 = "sha256-wTu1NphGoecl4kWNGJBK4RyldoEaWcN01v6zD0g2Zh8=";
        }
        {
          publisher = "ms-python";
          name = "black-formatter";
          version = "2024.6.0";
          sha256 = "sha256-Waw+WhazNqVoihC/K/tPFH4tCeYYVOFDBfg+AWvs3q4=";
        }
        {
          publisher = "ms-python";
          name = "debugpy";
          version = "2025.0.1";
          sha256 = "sha256-IPjQY8G1JvpcjZWRsk1+Z8yIZ1UG0jIxmNsNXcHr+bs=";
        }
        {
          publisher = "ms-python";
          name = "isort";
          version = "2023.10.1";
          sha256 = "sha256-NRsS+mp0pIhGZiqxAMXNZ7SwLno9Q8pj+RS1WB92HzU=";
        }
        {
          publisher = "ms-python";
          name = "python";
          version = "2024.16.0";
          sha256 = "sha256-LyamFBiLZpQMMk0z0gudaCeDMuV1bDHtvJIoI2Wnu6A=";
        }
        {
          publisher = "ms-python";
          name = "vscode-pylance";
          version = "2025.2.1";
          sha256 = "sha256-8aqua60QeKue8DUpRQynUQRm2tZNt8qq/OS8VdWTDas=";
        }
        {
          publisher = "ms-toolsai";
          name = "jupyter";
          version = "2024.8.1";
          sha256 = "sha256-eFInKB1xwVVJFIsXHxsuRJeLKTe3Cb8svquHJOW0P+I=";
        }
        {
          publisher = "ms-toolsai";
          name = "jupyter-renderers";
          version = "1.0.19";
          sha256 = "sha256-15333GNQZhuJGOskz0FEi3mTdGO8ocfYpfZyyUbGYbM=";
        }
        {
          publisher = "ms-toolsai";
          name = "vscode-jupyter-cell-tags";
          version = "0.1.9";
          sha256 = "sha256-XODbFbOr2kBTzFc0JtjiDUcCDBX1Hd4uajlil7mhqPY=";
        }
        {
          publisher = "ms-toolsai";
          name = "vscode-jupyter-slideshow";
          version = "0.1.6";
          sha256 = "sha256-fnsMrrcYdz6BzUWMd9pAOQGTjmtEbQeoVYG20VWxCsM=";
        }
        {
          publisher = "ms-vscode-remote";
          name = "remote-containers";
          version = "0.397.0";
          sha256 = "sha256-RL8FjGVyu6SaLBpcbsgDohRSAA22wYyaL0ReOovclhU=";
        }
        {
          publisher = "ms-vscode-remote";
          name = "remote-ssh";
          version = "0.115.1";
          sha256 = "sha256-0KwkfFGAJumH8+eqcoK6ZYOezAPVAomvL+rJfEhV64U=";
        }
        {
          publisher = "ms-vscode-remote";
          name = "remote-ssh-edit";
          version = "0.87.0";
          sha256 = "sha256-yeX6RAJl07d+SuYyGQFLZNcUzVKAsmPFyTKEn+y3GuM=";
        }
        {
          publisher = "ms-vscode";
          name = "azure-repos";
          version = "0.40.0";
          sha256 = "sha256-WiTp7G6ZfM5N9utHnjZLPDtPhDXg4+QTCOlc/XhZ+L8=";
        }
        {
          publisher = "ms-vscode";
          name = "cmake-tools";
          version = "1.20.53";
          sha256 = "sha256-yDJOMamnNGmaZTZkN7WCkiLgLTtVJan0tv0MOg2oNA4=";
        }
        {
          publisher = "ms-vscode";
          name = "cpptools";
          version = "1.23.6";
          sha256 = "sha256-4wU4zoddbJVGvYO7VLORB1nrqfXXXynUG+VyM5rdw/U=";
        }
        {
          publisher = "ms-vscode";
          name = "cpptools-extension-pack";
          version = "1.3.1";
          sha256 = "sha256-HbI0UdN8uwHS2MPH1SGZhxNaN18cWzjMyWYcgVE7FjY=";
        }
        {
          publisher = "ms-vscode";
          name = "hexeditor";
          version = "1.11.1";
          sha256 = "sha256-RB5YOp30tfMEzGyXpOwPIHzXqZlRGc+pXiJ3foego7Y=";
        }
        {
          publisher = "ms-vscode";
          name = "remote-explorer";
          version = "0.4.3";
          sha256 = "sha256-772l0EnAWXLg53TxPZf93js/W49uozwdslmzNwD1vIk=";
        }
        {
          publisher = "ms-vscode";
          name = "remote-repositories";
          version = "0.42.0";
          sha256 = "sha256-cYbkCcNsoTO6E5befw/ZN3yTW262APTCxyCJ/3z84dc=";
        }
        {
          publisher = "ms-vsliveshare";
          name = "vsliveshare";
          version = "1.0.5948";
          sha256 = "sha256-KOu9zF5l6MTLU8z/l4xBwRl2X3uIE15YgHEZJrKSHGY=";
        }
        {
          publisher = "mshr-h";
          name = "veriloghdl";
          version = "1.16.0";
          sha256 = "sha256-5C9SggdZ3gtYdQhpPFG4wme98b3VgKicXUpPn84gYb4=";
        }
        {
          publisher = "mtxr";
          name = "sqltools";
          version = "0.28.4";
          sha256 = "sha256-ExeerCI5yDa/DJqNOwENDjw+xhMPNil6JgCAUNdTXy8=";
        }
        {
          publisher = "mtxr";
          name = "sqltools-driver-pg";
          version = "0.5.5";
          sha256 = "sha256-B1wycDFSWPaQ87HF54+GrNX0b5f3tODLStuxqICdkjs=";
        }
        {
          publisher = "nataniel4";
          name = "xcode-vscode-theme";
          version = "1.0.3";
          sha256 = "sha256-pMCb8vpsRec7+KX2deE3gIvNsIeSS8pCopW0tbOtbig=";
        }
        {
          publisher = "okteto";
          name = "remote-kubernetes";
          version = "0.5.1";
          sha256 = "sha256-XC8hkUDuB57UZc2bjxrZZtoWnX4Qi+k4OFZbKYH5VKQ=";
        }
        {
          publisher = "openai";
          name = "chatgpt";
          version = "0.4.46";
          sha256 = "sha256-fR2jZILAyqImcEtiVc+wx8nSuBEcsenSK9ZYqVTq2JI=";
        }
        {
          publisher = "pgourlain";
          name = "erlang";
          version = "1.1.2";
          sha256 = "sha256-TOhuaVV+FWLSJhnnPlAFHXLJsn9Tf/YZN8ct0FMh2NM=";
        }
        {
          publisher = "phoenixframework";
          name = "phoenix";
          version = "0.1.3";
          sha256 = "sha256-UuGqYLz/4lc5WngrRLkAbEXnOW5pvTlDhHO0aB+LRgk=";
        }
        {
          publisher = "pnp";
          name = "polacode";
          version = "0.3.4";
          sha256 = "sha256-u06gIe86W2dX4a1dBK4m07/VQeQKWMCwzi9LmSWpLFE=";
        }
        {
          publisher = "ptd";
          name = "vscode-unitymeta";
          version = "0.0.7";
          sha256 = "sha256-h1tO3PJGYMeYVNmAISUIkWwyroJq4oyWwuc1jmgVSK8=";
        }
        {
          publisher = "quicktype";
          name = "quicktype";
          version = "23.0.170";
          sha256 = "sha256-lK50+WXPXHgqryhlsMb+65yoebX0Rh3PNKmlUjfwlOc=";
        }
        {
          publisher = "redhat";
          name = "java";
          version = "1.40.0";
          sha256 = "sha256-0airNWp1pcP9ntPVZqTVquN917pjVJxNEv4lWsqHn/w=";
        }
        {
          publisher = "redhat";
          name = "vscode-xml";
          version = "0.27.2";
          sha256 = "sha256-yE8PfDpdrYtegJZ/9UaljuEw/y9gokPngsFvbfMSJ2g=";
        }
        {
          publisher = "redhat";
          name = "vscode-yaml";
          version = "1.16.0";
          sha256 = "sha256-3cuonI98gVFE/GwPA7QCA1LfSC8oXqgtV4i6iOngwhk=";
        }
        {
          publisher = "rimuruchan";
          name = "vscode-fix-checksums-next";
          version = "1.3.0";
          sha256 = "sha256-0g05H7uNXJSFaHWUlfWlh5CQV0UPPI2AFzJrt/p2OWY=";
        }
        {
          publisher = "shopify";
          name = "ruby-lsp";
          version = "0.9.7";
          sha256 = "sha256-7vLT5vvqqwT0Tlt/iHXW0ktp2It7l+lxUWNJEljIp4c=";
        }
        {
          publisher = "slevesque";
          name = "shader";
          version = "1.1.5";
          sha256 = "sha256-Pf37FeQMNlv74f7LMz9+CKscF6UjTZ7ZpcaZFKtX2ZM=";
        }
        {
          publisher = "slevesque";
          name = "vscode-3dviewer";
          version = "0.2.2";
          sha256 = "sha256-aOqdZYksIPhzWob9P4TrHd+M8v9YWohzuPEiAUI3opk=";
        }
        {
          publisher = "stefanjarina";
          name = "vscode-eex-snippets";
          version = "0.0.8";
          sha256 = "sha256-1Qy5puUMwDdFxTAeKAf1RNW8+78klY7hRiNMGnSuF0k=";
        }
        {
          publisher = "stephanvs";
          name = "dot";
          version = "0.0.1";
          sha256 = "sha256-7u3MRMcaC3EL6cNxmjZQVTo7z6m+c03WJ+89tuzmAGc=";
        }
        {
          publisher = "streetsidesoftware";
          name = "code-spell-checker";
          version = "4.0.31";
          sha256 = "sha256-8F9lhHkr11XeFbVsArdVvNe6NADGkMFQJoWN0sntf5s=";
        }
        {
          publisher = "streetsidesoftware";
          name = "code-spell-checker-russian";
          version = "2.2.2";
          sha256 = "sha256-O/NPuehch2Iub4PJYubka06jQaR8jv0BOMuUfBZhuqY=";
        }
        {
          publisher = "swiftlang";
          name = "swift-vscode";
          version = "2.14.1";
          sha256 = "sha256-Pd9RJ4UuzoybhOJ0qVn0FKMI01OcX0ZrMHw5bfd1iog=";
        }
        {
          publisher = "sztheory";
          name = "hex-lens";
          version = "0.0.2";
          sha256 = "sha256-B1jYkxGCNEBIcEW7B4hYLee6zT1sRo8KhojGwXm+610=";
        }
        {
          publisher = "techer";
          name = "open-in-browser";
          version = "2.0.0";
          sha256 = "sha256-3XYRMuWEJfhureHmx1KfT+N9aBuqDagj0FErJQF/teg=";
        }
        {
          publisher = "theonekevin";
          name = "icarusext";
          version = "1.0.3";
          sha256 = "sha256-6zxyIqFFYxj4MAdU1TADz6eeTglMdLD2pKm4yJVU5e8=";
        }
        {
          publisher = "tim-koehler";
          name = "helm-intellisense";
          version = "0.14.3";
          sha256 = "sha256-TcXn8n6mKEFpnP8dyv+nXBjsyfUfJNgdL9iSZwA5eo0=";
        }
        {
          publisher = "tintinweb";
          name = "graphviz-interactive-preview";
          version = "0.3.5";
          sha256 = "sha256-5A+RXGGVF/LY2IQ9jDvmS2/G6/T9BBqDPIx+7SXNeTo=";
        }
        {
          publisher = "torn4dom4n";
          name = "latex-support";
          version = "3.10.0";
          sha256 = "sha256-kPhe102Lwcz4yelfxSj+n+Dob9fwoyZPYsUIupOrw8w=";
        }
        {
          publisher = "twxs";
          name = "cmake";
          version = "0.0.17";
          sha256 = "sha256-CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
        }
        {
          publisher = "ultram4rine";
          name = "sqltools-clickhouse-driver";
          version = "0.9.0";
          sha256 = "sha256-40t2fg7sTAJ5AHZCoPUrbuX5GrBXa3PpzGnN5rIAvQo=";
        }
        {
          publisher = "unifiedjs";
          name = "vscode-mdx";
          version = "1.8.13";
          sha256 = "sha256-QTIDs+HVnM+zJ3jqhiBhUTsrI44kaHInYDXLXMC1/9E=";
        }
        {
          publisher = "usernamehw";
          name = "errorlens";
          version = "3.23.0";
          sha256 = "sha256-mz3JU4+/P6nM/SEJcVG5gq5K1Ym9L8N2pXbfw8a5DoA=";
        }
        {
          publisher = "vadimcn";
          name = "vscode-lldb";
          version = "1.11.4";
          sha256 = "sha256-ylWlqKSiqsOL1S4vaFKLDck1wGm155bEGGL4+sKdBF8=";
        }
        {
          publisher = "valentin";
          name = "beamdasm";
          version = "1.1.5";
          sha256 = "sha256-EN+lvRoiOgfx0Uy/HeuaVPG9d654pV2kO2LoiVUFgMI=";
        }
        {
          publisher = "vintharas";
          name = "learn-vim";
          version = "0.0.28";
          sha256 = "sha256-HAEKetNHUZ1HopGeQTqkrGUWZNFWD7gMaoTNbpxqI1Y=";
        }
        {
          publisher = "visualstudiotoolsforunity";
          name = "vstuc";
          version = "1.1.0";
          sha256 = "sha256-86KDksbTKlPgKC1joUc7uQTsDe2w9AIL0fekZP0z6gE=";
        }
        {
          publisher = "vscjava";
          name = "vscode-gradle";
          version = "3.16.4";
          sha256 = "sha256-PDf6tvuliPvAcYVDbzIsklFs60ADCwAD6e4MLvDRF6k=";
        }
        {
          publisher = "vscjava";
          name = "vscode-java-debug";
          version = "0.58.1";
          sha256 = "sha256-S+kNAaYBjVxAuYlMbpQUM9DyTW76yRvokTzl+32pUgc=";
        }
        {
          publisher = "vscjava";
          name = "vscode-java-dependency";
          version = "0.24.1";
          sha256 = "sha256-M0y6/9EPkcXTMxArqLpfSeVKpVF2SvjLtTWvLMIvauY=";
        }
        {
          publisher = "vscjava";
          name = "vscode-java-pack";
          version = "0.29.0";
          sha256 = "sha256-qusk1X3mgRdzb4MRBr9WyOViG9UGYFDIv3aQOSrMSVo=";
        }
        {
          publisher = "vscjava";
          name = "vscode-java-test";
          version = "0.43.0";
          sha256 = "sha256-EM0S1Y4cRMBCRbAZgl9m6fIhANPrvdGVZXOLlDLnVWo=";
        }
        {
          publisher = "vscjava";
          name = "vscode-maven";
          version = "0.44.0";
          sha256 = "sha256-w9fiFWkF5CLmwtxldE430N3iSiTKdAH1Maly+4Omn1o=";
        }
        {
          publisher = "vue";
          name = "volar";
          version = "2.2.8";
          sha256 = "sha256-efEeTq/y4al38Tdut3bHVdluf3tUYqc6CFPX+ch1gLg=";
        }
        {
          publisher = "wmaurer";
          name = "change-case";
          version = "1.0.0";
          sha256 = "sha256-tN/jlG2PzuiCeERpgQvdqDoa3UgrUaM7fKHv6KFqujc=";
        }
        {
          publisher = "yzhang";
          name = "markdown-all-in-one";
          version = "3.6.2";
          sha256 = "sha256-BIbgUkIuy8clq4G4x1Zd08M8k4u5ZPe80+z6fSAeLdk=";
        }
        {
          publisher = "zerokol";
          name = "vscode-eex-beautify";
          version = "0.2.3";
          sha256 = "sha256-mNKQDovXufkJ5/EZJetDeByXatWlYYL8Lu60eOtZKlo=";
        }
        {
          publisher = "ziglang";
          name = "vscode-zig";
          version = "0.6.4";
          sha256 = "sha256-+LqBhrB6EL66IpBnmJzGzPOhwmlz7L6hdVWV/NZMa7Y=";
        }
        {
          publisher = "zxh404";
          name = "vscode-proto3";
          version = "0.5.5";
          sha256 = "sha256-Em+w3FyJLXrpVAe9N7zsHRoMcpvl+psmG1new7nA8iE=";
        }
      ];

      userSettings = {
        # General Configuration
        "update.mode" = "none";
        "window.titleBarStyle" = "native";
        "window.customTitleBarVisibility" = "never";
        "window.commandCenter" = false;
        "editor.detectIndentation" = false;
        "editor.tabSize" = 2;
        "editor.indentSize" = "tabSize";
        "editor.formatOnSave" = true;
        "editor.largeFileOptimizations" = false;
        "files.autoSaveDelay" = 200;
        "files.exclude" = {
          "**/*.meta" = true;
        };
        "workbench.editor.showIcons" = false;
        "workbench.editor.tabActionLocation" = "left";
        "security.workspace.trust.enabled" = false;

        # Theme & UI
        "workbench.colorTheme" = "MacOS Modern Dark - Ventura Xcode Default";
        "workbench.iconTheme" = "macos-modern-big-sur-icon-theme";
        "editor.tokenColorCustomizations" = {
          textMateRules = [
            {
              scope = "comment";
              settings.fontStyle = "italic";
            }
            {
              scope = "constant.language";
              settings.fontStyle = "bold";
            }
            {
              scope = "entity.name.function-call";
              settings.foreground = "#91D462";
            }
            {
              scope = "entity.name.type";
              settings.foreground = "#53A5FB";
            }
            {
              scope = "keyword.operator";
              settings.fontStyle = "";
            }
            {
              scope = "keyword";
              settings.fontStyle = "bold";
            }
            {
              scope = "storage";
              settings.fontStyle = "bold";
            }
            {
              scope = "variable.other.readwrite";
              settings.foreground = "#FFFFFFD8";
            }
          ];
        };

        # Font Configuration
        "editor.fontFamily" = "'FiraCode Nerd Font', 'SF Mono', Menlo, Monaco, 'Courier New', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 12;
        "editor.fontWeight" = "normal";
        "editor.lineHeight" = 17;

        # Error Highlighting & Minimap
        "editor.renderLineHighlight" = "all";
        "editor.unicodeHighlight.ambiguousCharacters" = false;
        "editor.minimap.enabled" = false;
        "editor.minimap.renderCharacters" = false;
        "editor.minimap.showSlider" = "always";
        "editor.overviewRulerBorder" = false;

        # Color Customization
        "workbench.colorCustomizations" = {
          "editorError.foreground" = "#e4545460";
          "editorWarning.foreground" = "#ff942f60";
          "editorInfo.foreground" = "#00b7e460";
          "editorHint.foreground" = "#17a2a260";
          "editorError.background" = "#e4545460";
          "editorWarning.background" = "#ff942f60";
          "editorInfo.background" = "#00b7e460";
          "editorHint.background" = "#17a2a260";
          "terminal.background" = "#00000000";
        };

        # Scrollbar Tweaks
        "editor.scrollbar.horizontalScrollbarSize" = 0;
        "editor.scrollbar.verticalScrollbarSize" = 0;
        "editor.stickyScroll.enabled" = true;

        # Terminal Configuration
        "terminal.explorerKind" = "external";
        "terminal.external.osxExec" = "iTerm2.app";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.customGlyphs" = true;
        "terminal.integrated.fontSize" = 12;
        "terminal.integrated.gpuAcceleration" = "off";
        "terminal.integrated.lineHeight" = 1.23;

        # Git & GitHub
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "gitlens.statusBar.enabled" = false;
        "gitlens.views.branches.avatars" = false;
        "gitlens.plusFeatures.enabled" = false;
        "githubPullRequests.fileListLayout" = "tree";
        "githubPullRequests.pullBranch" = "never";

        # Copilot & AI Features
        "chat.agent.enabled" = true;
        "chat.extensionTools.enabled" = true;

        # Programming Language Settings
        ## Kubernetes & Helm

        "[helm]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };

        "[helm-template]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };

        "[dockerfile]" = {
          "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
        };

        "vs-kubernetes" = {
          "vs-kubernetes.crd-code-completion" = "enabled";
          "vs-kubernetes.minikube-show-information-expiration" = "2025-08-11T15:45:08.954Z";
        };

        ## Markdown

        "[markdown]" = {
          "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        };

        ## OpenAPI
        "openapi.defaultPreviewRenderer" = "redoc";

        ## Python
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.autopep8";
        };

        ## Typst

        "tinymist.serverPath" = "tinymist";

        ## Shell

        "shellformat.path" = "${pkgs.shfmt}/bin/shfmt";

        ## XML

        "[xml]" = {
          "editor.defaultFormatter" = "redhat.vscode-xml";
        };

        # Spellcheck
        "cSpell.language" = "en,ru";

        # Miscellaneous
        "redhat.telemetry.enabled" = false;
        "polacode.transparentBackground" = true;
        "terminal.integrated.enableVisualBell" = true;
      };

      keybindings = [
        {
          key = "cmd+b";
          command = "workbench.action.toggleSidebarVisibility";
          when = "!(resourceFilename =~ /.drawio./)";
        }
        {
          key = "cmd+b";
          command = "-workbench.action.toggleSidebarVisibility";
        }
      ];
    };
  };
}
