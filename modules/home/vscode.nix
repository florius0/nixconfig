{ lib, pkgs, ... }:

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
          publisher = "archicionado";
          name = "cornifer";
          version = "2.1.0";
          sha256 = "sha256-sllNzfh/98YTsRgkDzYhswl4dn478788IxNscYIY6BY=";
        }
        {
          publisher = "attilabuti";
          name = "vscode-mjml";
          version = "1.6.0";
          sha256 = "sha256-zZ+SbhNTzVxdECXbicVxVmLPlqHuTmzFq6UDeoLfGaA=";
        }
        {
          publisher = "benvp";
          name = "vscode-hex-pm-intellisense";
          version = "0.5.0";
          sha256 = "sha256-KzDy9YaS0iXlYJdK1HFQNQTXT/EOjqwhE+21cA9Hr0k=";
        }
        {
          publisher = "cesium";
          name = "gltf-vscode";
          version = "2.5.1";
          sha256 = "sha256-EFgYQO3Eu68VynkObLeNcHtHizF5il5qLE3drbatwyQ=";
        }
        {
          publisher = "christian-kohler";
          name = "path-intellisense";
          version = "2.10.0";
          sha256 = "sha256-bE32VmzZBsAqgSxdQAK9OoTcTgutGEtgvw6+RaieqRs=";
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
          publisher = "denco";
          name = "confluence-markup";
          version = "1.0.4";
          sha256 = "sha256-3XpSMMi2ZawgFIvTBbMH9Mxma2TKCk9fNgftYuW9M8Y=";
        }
        {
          publisher = "earthly";
          name = "earthfile-syntax-highlighting";
          version = "0.0.16";
          sha256 = "sha256-xU1v1NL1A6EDG+kv8Ri16xuZeQdRFzTnMOCLGpCmlg8=";
        }
        {
          publisher = "ExpertLSP";
          name = "expert";
          version = "0.3.1";
          sha256 = "sha256-+PS0gHfa9DeQWGXBwRdaK2Eo7gZcq3JQqcAyaTlJe+E=";
        }
        {
          publisher = "foxundermoon";
          name = "shell-format";
          version = "7.2.5";
          sha256 = "sha256-kfpRByJDcGY3W9+ELBzDOUMl06D/vyPlN//wPgQhByk=";
        }
        {
          publisher = "golang";
          name = "go";
          version = "0.46.1";
          sha256 = "sha256-R5SC6vMWT3alunlklJKcEKKJhNd6GI2MF9/QWwuNprs=";
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
          publisher = "mattfoulks";
          name = "har-analyzer";
          version = "0.0.11";
          sha256 = "sha256-JSkIYJcH0wPEPhqZOiDCGhocDe5Eubj1MocjJKS3qCE=";
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
          version = "0.14.16";
          sha256 = "sha256-R4tlQgtQaXIT6qiBg1RqQB0Usnsj0Ijs2Bhn2J1CQq4=";
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
          publisher = "ms-python";
          name = "autopep8";
          version = "2024.2.0";
          sha256 = "sha256-wTu1NphGoecl4kWNGJBK4RyldoEaWcN01v6zD0g2Zh8=";
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
          name = "hexeditor";
          version = "1.11.1";
          sha256 = "sha256-RB5YOp30tfMEzGyXpOwPIHzXqZlRGc+pXiJ3foego7Y=";
        }
        {
          publisher = "mshr-h";
          name = "veriloghdl";
          version = "1.16.0";
          sha256 = "sha256-5C9SggdZ3gtYdQhpPFG4wme98b3VgKicXUpPn84gYb4=";
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
          publisher = "twxs";
          name = "cmake";
          version = "0.0.17";
          sha256 = "sha256-CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
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
          publisher = "valentin";
          name = "beamdasm";
          version = "1.1.5";
          sha256 = "sha256-EN+lvRoiOgfx0Uy/HeuaVPG9d654pV2kO2LoiVUFgMI=";
        }
        {
          publisher = "visualstudiotoolsforunity";
          name = "vstuc";
          version = "1.1.0";
          sha256 = "sha256-86KDksbTKlPgKC1joUc7uQTsDe2w9AIL0fekZP0z6gE=";
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
        # Updates
        "update.mode" = "none";
        "extensions.autoUpdate" = "off";

        # General Configuration
        "breadcrumbs.showEditorType" = true;
        "editor.detectIndentation" = false;
        "editor.formatOnSave" = true;
        "editor.indentSize" = "tabSize";
        "editor.largeFileOptimizations" = false;
        "editor.tabSize" = 2;
        "files.autoSaveDelay" = 200;
        "files.exclude" = {
          "**/*.meta" = true;
        };
        "security.workspace.trust.enabled" = false;
        "window.commandCenter" = false;
        "window.customTitleBarVisibility" = "never";
        "window.titleBarStyle" = "native";
        "workbench.editor.showIcons" = false;
        "workbench.editor.tabActionLocation" = "left";
        "workbench.startupEditor" = "none";

        # Theme & UI
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
        "workbench.colorTheme" = "MacOS Modern Dark - Ventura Xcode Default";
        "workbench.iconTheme" = "macos-modern-big-sur-icon-theme";

        # Font Configuration
        "editor.fontFamily" = "'FiraCode Nerd Font', 'SF Mono', Menlo, Monaco, 'Courier New', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 12;
        "editor.fontWeight" = "normal";
        "editor.lineHeight" = 17;

        # Error Highlighting & Minimap
        "editor.minimap.enabled" = false;
        "editor.minimap.renderCharacters" = false;
        "editor.minimap.showSlider" = "always";
        "editor.overviewRulerBorder" = false;
        "editor.renderLineHighlight" = "all";
        "editor.unicodeHighlight.ambiguousCharacters" = false;

        # Color Customization
        "workbench.colorCustomizations" = {
          "editorError.background" = "#e4545460";
          "editorError.foreground" = "#e4545460";
          "editorHint.background" = "#17a2a260";
          "editorHint.foreground" = "#17a2a260";
          "editorInfo.background" = "#00b7e460";
          "editorInfo.foreground" = "#00b7e460";
          "editorWarning.background" = "#ff942f60";
          "editorWarning.foreground" = "#ff942f60";
          "terminal.background" = "#00000000";
        };

        # Scrollbar Tweaks
        "editor.scrollbar.horizontalScrollbarSize" = 0;
        "editor.scrollbar.verticalScrollbarSize" = 0;
        "editor.stickyScroll.enabled" = true;

        # Terminal Configuration
        "terminal.explorerKind" = "external";
        "terminal.external.osxExec" = "${pkgs.ghostty-bin}/Applications/Ghostty.app";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.customGlyphs" = true;
        "terminal.integrated.fontSize" = 12;
        "terminal.integrated.gpuAcceleration" = "off";
        "terminal.integrated.lineHeight" = 1.23;

        # Git & GitHub
        "diffEditor.ignoreTrimWhitespace" = false;
        "git.autofetch" = true;
        "git.blame.editorDecoration.enabled" = true;
        "git.blame.statusBarItem.enabled" = false;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "scm.defaultViewMode" = "tree";
        "scm.diffDecorationsIgnoreTrimWhitespace" = false;

        # Search
        "search.defaultViewMode" = "tree";

        # Copilot & AI Features
        "chat.agent.enabled" = true;
        "chat.extensionTools.enabled" = true;
        "chat.agentHost.enabled" = true;
        "editor.inlineSuggest.enabled" = false;
        "github.copilot.enable" = false;

        # Programming Language Settings
        ## Kubernetes & Helm

        "[helm]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };

        "[helm-template]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };

        "[dockerfile]" = {
          "editor.defaultFormatter" = "foxundermoon.shell-format";
        };

        ## Markdown

        "[markdown]" = {
          "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        };

        ## PlantUML
        "plantuml.render" = "PlantUMLServer";
        "plantuml.server" = "http://127.0.0.1:18765/plantuml";

        ## OpenAPI
        "openapi.defaultPreviewRenderer" = "redoc";

        ## Python
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.autopep8";
        };

        ## Typst

        "tinymist.serverPath" = "tinymist";

        ## Shell

        "shellformat.path" = "${lib.getExe pkgs.shfmt}";

        ## XML

        "[xml]" = {
          "editor.defaultFormatter" = "redhat.vscode-xml";
        };

        # Spellcheck
        "cSpell.language" = "en,ru";

        # Miscellaneous
        "polacode.transparentBackground" = true;
        "redhat.telemetry.enabled" = false;
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
        {
          key = "cmd+9";
          command = "workbench.action.lastEditorInGroup";
        }
        {
          key = "ctrl+9";
          command = "workbench.action.focusLastEditorGroup";
        }
        {
          key = "ctrl+tab";
          command = "-workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup";
        }
        {
          key = "ctrl+shift+tab";
          command = "-workbench.action.quickOpenLeastRecentlyUsedEditorInGroup";
        }
      ]
      ++ lib.concatLists (
        lib.imap1
          (index: group: [
            {
              key = "cmd+${toString index}";
              command = "workbench.action.openEditorAtIndex${toString index}";
            }
            {
              key = "ctrl+${toString index}";
              command = "workbench.action.focus${group}EditorGroup";
            }
          ])
          [
            "First"
            "Second"
            "Third"
            "Fourth"
            "Fifth"
            "Sixth"
            "Seventh"
            "Eighth"
          ]
      );
    };
  };
}
