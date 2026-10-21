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
          version = "5.10.0";
          sha256 = "sha256-uRsbU9xR+IqTZPtCadQjDb3LbF2ggG1MGc4NAfyD8DE=";
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
          version = "2.2.0";
          sha256 = "sha256-9jLdfnu3ClyyTceTFvqQYpduhfyjed7dTHvHTEE2g8o=";
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
          version = "3.144.0";
          sha256 = "sha256-7dOKbXS7S+Z0o3E4DAhgKWJAlu3YA8AKebqJQaw3Utw=";
        }
        {
          publisher = "davidanson";
          name = "vscode-markdownlint";
          version = "0.62.1";
          sha256 = "sha256-zR0pWpxWTTxeAEfX49vlhaTPc2YZxcJCv62abriPtRg=";
        }
        {
          publisher = "davidbwaters";
          name = "macos-modern-theme";
          version = "2.3.19";
          sha256 = "sha256-/gpGu3vvomQA0TC+TBJkBe2AFWimIyiMM5fndYF8G/A=";
        }
        {
          publisher = "earthly";
          name = "earthfile-syntax-highlighting";
          version = "0.0.16";
          sha256 = "sha256-xU1v1NL1A6EDG+kv8Ri16xuZeQdRFzTnMOCLGpCmlg8=";
        }
        {
          publisher = "remoteoss";
          name = "dexter-lsp";
          version = "0.3.0";
          sha256 = "sha256-BH/KVYqBNH+01swb1Hn0lSy7lfjU57LPLaN3GSDGOK0=";
        }
        {
          publisher = "foxundermoon";
          name = "shell-format";
          version = "7.2.8";
          sha256 = "sha256-Z3vmRzqPCxkQbn39I54bh/ND+0HcE9iFUhKQ29GRd7o=";
        }
        {
          publisher = "golang";
          name = "go";
          version = "0.58.0";
          sha256 = "sha256-vGONEYBB/pHCtDfHvEeK2snhuVJUkKs5dw9L8Q9Yp40=";
        }
        {
          publisher = "haskell";
          name = "haskell";
          version = "2.8.2";
          sha256 = "sha256-daTBaTSmytANeS/odxELqc4GB7FeBa66n1FDUKIDlKc=";
        }
        {
          publisher = "hediet";
          name = "vscode-drawio";
          version = "1.17.0";
          sha256 = "sha256-KYVxvE5/kVMcWCdEDcl3DA8sj0k/41flMi/Pro/11Kw=";
        }
        {
          publisher = "james-yu";
          name = "latex-workshop";
          version = "10.20.0";
          sha256 = "sha256-GBl9ZY3ZglsxqW+eJd9cpo6HkAA54HerqCGMcat24fc=";
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
          version = "0.5.13";
          sha256 = "sha256-0pMMnYFX+Ghs42Tvfcv9QqwhrEhCjIa7+6xJ51Fa0Dk=";
        }
        {
          publisher = "haskell";
          name = "language-haskell";
          version = "3.8.0";
          sha256 = "sha256-wDGvGKI+YDwkbYKV0ijnB3+NwWPZAuwLN4MpFV37KFs=";
        }
        {
          publisher = "kabie";
          name = "elixir-zigler";
          version = "0.1.0";
          sha256 = "sha256-ELmxthy6rO1IVmTQitbzh7M6e3EZr9CWhqkTF4UREh0=";
        }
        {
          publisher = "llvm-vs-code-extensions";
          name = "lldb-dap";
          version = "0.4.1";
          sha256 = "sha256-7eMVniepE4lDLAYsMpE5bKYvkfskGaOapxYUJy58mJA=";
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
          version = "0.15.10";
          arch = "darwin-arm64";
          sha256 = "sha256-/o1eeccDuP6L/WA6VOIOt8pdIZ0Pu+ob5xywKiAWycM=";
        }
        {
          publisher = "ms-dotnettools";
          name = "csdevkit";
          version = "3.40.215";
          arch = "darwin-arm64";
          sha256 = "sha256-0xS00p7fXipjYhb02nfMt+hMamK8AyYjciyxxnzBCn4=";
        }
        {
          publisher = "ms-dotnettools";
          name = "csharp";
          version = "2.160.4";
          arch = "darwin-arm64";
          sha256 = "sha256-LXAtSvfxEGxt7YHMl8S9imDIb6/Mfi7BsTamwnx9sGE=";
        }
        {
          publisher = "ms-dotnettools";
          name = "vscode-dotnet-runtime";
          version = "3.2.0";
          sha256 = "sha256-DvoaWpG8qFNjGl9xVRqBvymucGm9UQ9VOMx+X7EvBUA=";
        }
        {
          publisher = "ms-python";
          name = "autopep8";
          version = "2026.4.0";
          sha256 = "sha256-pr2lIWBV1Uya09lMa8BXzVRBjP5NRzmbkuLqFwGwq/U=";
        }
        {
          publisher = "ms-python";
          name = "debugpy";
          version = "2026.6.0";
          arch = "darwin-arm64";
          sha256 = "sha256-mmvbMMfwtgLXgZoIn+4wQ4IVbuo8gwFTplGcHkh3PuA=";
        }
        {
          publisher = "ms-python";
          name = "isort";
          version = "2026.6.0";
          sha256 = "sha256-bWkn9XPgHqYDOlT3W0kJvF7q1WnQblwhM9J2VecXjO0=";
        }
        {
          publisher = "ms-python";
          name = "python";
          version = "2026.10.0";
          arch = "darwin-arm64";
          sha256 = "sha256-HA3Fo+p4Y9y2ZzMY2OL1d/G8yDmRRm+hizKGI+V2qC8=";
        }
        {
          publisher = "ms-python";
          name = "vscode-pylance";
          version = "2026.4.1";
          sha256 = "sha256-PmydC6DGaA5u8o0a9cbhOETjmoceVATL+qrttc0NjPs=";
        }
        {
          publisher = "ms-toolsai";
          name = "jupyter";
          version = "2025.9.1";
          arch = "darwin-arm64";
          sha256 = "sha256-OBmTKOaCvaJB98KyZhAT9fR4JsEzo4BWXVnqEQovoGQ=";
        }
        {
          publisher = "ms-toolsai";
          name = "jupyter-renderers";
          version = "1.3.0";
          sha256 = "sha256-GBqHvXikCgLGW7Xm05Iq1xqs8j9H9k9c8iASsAjA87I=";
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
          version = "1.24.42";
          sha256 = "sha256-FNbfOhFhmRXVofoqRs8lTf9jTuNOBvakZGaKr6fVXrs=";
        }
        {
          publisher = "ms-vscode";
          name = "cpptools";
          version = "1.34.4";
          arch = "darwin-arm64";
          sha256 = "sha256-yiNgrk6+qnSqATx94D14OFlStIgHnF3NXiwL/AY9Yuo=";
        }
        {
          publisher = "ms-vscode";
          name = "hexeditor";
          version = "1.11.1";
          sha256 = "sha256-RB5YOp30tfMEzGyXpOwPIHzXqZlRGc+pXiJ3foego7Y=";
        }
        {
          publisher = "pgourlain";
          name = "erlang";
          version = "1.2.8";
          sha256 = "sha256-FtlTwUL6CguxxoVgNQJ7DzUhAYxTOKEhUf8RMsRz0K0=";
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
          version = "1.58.0";
          arch = "darwin-arm64";
          sha256 = "sha256-h4OzMx1rNeiugIM+dpdO28ovpfOp2ZQ7WYaACH0rJOg=";
        }
        {
          publisher = "redhat";
          name = "vscode-xml";
          version = "0.29.3";
          sha256 = "sha256-QDFipVNXk7DRCmjnMjjPjM1g+qtpLHGOfEr8k6ztbCA=";
        }
        {
          publisher = "redhat";
          name = "vscode-yaml";
          version = "2.0.0";
          sha256 = "sha256-S7pizNqWK3INywgp6Fz0EJyU6GZT3NOf11AMNoetjGA=";
        }
        {
          publisher = "rimuruchan";
          name = "vscode-fix-checksums-next";
          version = "1.4.0";
          sha256 = "sha256-maDOeRzBNuOkJ537rQhKc7yak2g0m9CLyWMSyJV0C3o=";
        }
        {
          publisher = "shopify";
          name = "ruby-lsp";
          version = "0.10.7";
          sha256 = "sha256-JOreql6ZbI8UOmtdNyVqPOeBG/MuaQbCWS35k6HfNvs=";
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
          version = "4.10.0";
          sha256 = "sha256-C1h6OMTHiIenghWPcnu9rd+rLerjzg2A77q0DVZHVjg=";
        }
        {
          publisher = "streetsidesoftware";
          name = "code-spell-checker-russian";
          version = "3.0.1";
          sha256 = "sha256-1EnLUZIK1vXV2p2KXtJIh3enEzg8WiSoPiehQMKm79c=";
        }
        {
          publisher = "swiftlang";
          name = "swift-vscode";
          version = "2.16.7";
          sha256 = "sha256-pgG43/qjQypIwvyuIFQICjrMr3FSV3L35YtQocWvP88=";
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
          version = "0.15.0";
          sha256 = "sha256-Tl0X2jtgTsjf2tvyAJLGxEGrmLXACYWWErcDJuQYg+o=";
        }
        {
          publisher = "tintinweb";
          name = "graphviz-interactive-preview";
          version = "0.3.5";
          sha256 = "sha256-5A+RXGGVF/LY2IQ9jDvmS2/G6/T9BBqDPIx+7SXNeTo=";
        }
        {
          publisher = "unifiedjs";
          name = "vscode-mdx";
          version = "1.8.18";
          sha256 = "sha256-93Cf4TH56UXdtJy4FtRf5lmjltzIDxnr7Q9yY0iqSps=";
        }
        {
          publisher = "usernamehw";
          name = "errorlens";
          version = "3.29.0";
          sha256 = "sha256-kK9Axp2tMUGZ/04VtL5hzg35zvnRIjHpnmCJt9OhHQ8=";
        }
        {
          publisher = "valentin";
          name = "beamdasm";
          version = "1.1.6";
          sha256 = "sha256-liGbCbdrBVNFTl/YBU/gRkZIAKWyghsNzuiiJxyu7f0=";
        }
        {
          publisher = "visualstudiotoolsforunity";
          name = "vstuc";
          version = "1.3.2";
          sha256 = "sha256-yEpkJB67ZuotioT6FghPoRfsCI4yfok14A6acfk+rr0=";
        }
        {
          publisher = "vue";
          name = "volar";
          version = "3.3.13";
          sha256 = "sha256-k5oXAxSreUgW4A6RfdftKaosRI3JyC0jpxJg3ZK+v6A=";
        }
        {
          publisher = "wmaurer";
          name = "change-case";
          version = "2.1.1";
          sha256 = "sha256-OzdBIR3bchZWMXrNJfhaNhVgoTzpTPZT2HV6Jjyn1m0=";
        }
        {
          publisher = "yzhang";
          name = "markdown-all-in-one";
          version = "3.6.3";
          sha256 = "sha256-xJhbFQSX1DDDp8iE/R8ep+1t5IRusBkvjHcNmvjrboM=";
        }
        {
          publisher = "ziglang";
          name = "vscode-zig";
          version = "0.6.19";
          sha256 = "sha256-kdoks0da6+uofzvN5lulkDAVihSS7xoF/Q6Fo5yzQbg=";
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
        "files.trimTrailingWhitespace" = true;
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
        "chat.disableAIFeatures" = true;
        "editor.inlineSuggest.enabled" = false;

        # Programming Language Settings
        ## Elixir
        "dexter.binary" = "${pkgs.dexter}/bin/dexter";
        "dexter.autoInstall" = false;
        "dexter.autoUpdate" = false;

        "[elixir]" = {
          "editor.defaultFormatter" = "remoteoss.dexter-lsp";
        };

        "[phoenix-heex]" = {
          "editor.defaultFormatter" = "remoteoss.dexter-lsp";
        };

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

        "shellformat.path" = lib.getExe pkgs.shfmt;

        ## Swift
        "swift.sourcekit-lsp.serverPath" = lib.getExe pkgs.sourcekit-lsp;

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
