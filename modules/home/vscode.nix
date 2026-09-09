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
          version = "2.1.2";
          sha256 = "sha256-PEzrJRm15ovSN6OoOKxb21O9C+NhqMBT0w7PMC8BB1Q=";
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
          version = "3.142.0";
          sha256 = "sha256-OzfMBDUtA9fu0DxgfpjmjVOeCgFqj1aoo09JYViNTb4=";
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
          publisher = "ExpertLSP";
          name = "expert";
          version = "0.6.0";
          sha256 = "sha256-1O3GVHSiN3U8cPCa0hRFiJ24c1dJsRZURamsPmsaIy0=";
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
          version = "0.56.1";
          sha256 = "sha256-RTZdpdEoTzUYspSfIYSB8envYiGz2Zmi4wgsy7Yeh0s=";
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
          version = "1.6.6";
          sha256 = "sha256-SPcSnS7LnRL5gdiJIVsFaN7eccrUHSj9uQYIQZllm0M=";
        }
        {
          publisher = "james-yu";
          name = "latex-workshop";
          version = "10.18.0";
          sha256 = "sha256-nuBx5ujJPbKvXRvIbUaPaIgoUeeYp4XwHwOdAjCVqUY=";
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
          version = "0.15.8";
          arch = "darwin-arm64";
          sha256 = "sha256-x/cSMy6RTccNoKjz1U+tc2dSrWdqliwsz3AbxvxAyL8=";
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
          version = "2026.4.0";
          arch = "darwin-arm64";
          sha256 = "sha256-XntiQmvagiSWcfVIp13CDq2RTZ4NhKOzf4QmecZjMIs=";
        }
        {
          publisher = "ms-python";
          name = "vscode-pylance";
          version = "2026.3.1";
          sha256 = "sha256-Jl1fmAtc4wPV0cUE8nbIZdOr1Kk8pmHUq6ZCT6k0k64=";
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
          publisher = "pgourlain";
          name = "erlang";
          version = "1.1.5";
          sha256 = "sha256-p+enVUzOIUHXuTKlJdJv/D2ZmbYULkpS8IZCW/ZeCeo=";
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
          version = "1.56.0";
          arch = "darwin-arm64";
          sha256 = "sha256-Ayaxm1XTeN/dEcwBqG62yQ/MQnVcVC9iYReb5B1+GBI=";
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
          version = "1.24.0";
          sha256 = "sha256-Bmh1gxKn+mvtolnKWmhJ2QxdUZ32QV7b4kbBNeBtcWg=";
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
          version = "0.10.6";
          sha256 = "sha256-5yEfTSgcSv9SQILOu7hyfNcK+m5IBHKpLDjXXwOZb/I=";
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
          version = "2.2.4";
          sha256 = "sha256-Vn/Vu502A9qPVHfnJ3CZUXcM2knIIG6bJHce0r72Rv0=";
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
          version = "1.8.13";
          sha256 = "sha256-QTIDs+HVnM+zJ3jqhiBhUTsrI44kaHInYDXLXMC1/9E=";
        }
        {
          publisher = "usernamehw";
          name = "errorlens";
          version = "3.28.0";
          sha256 = "sha256-7eu7y9IR1uxSFZ0IplDieFt3iWbcmdwf1lAcXq+S4C8=";
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
          version = "1.1.0";
          sha256 = "sha256-86KDksbTKlPgKC1joUc7uQTsDe2w9AIL0fekZP0z6gE=";
        }
        {
          publisher = "vue";
          name = "volar";
          version = "3.3.11";
          sha256 = "sha256-wdELoM6czn0lrk9GdmBh55xUKXEXu5pkfaiRJvF06ew=";
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
