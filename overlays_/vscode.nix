final: prev: {
  vscode = prev.vscode.overrideAttrs (
    finalAttrs: prevAttrs: {
      postInstall = (prevAttrs.postInstall or "") + ''
        echo "Injecting custom VSCode CSS"
        # Append custom styles to the existing CSS file
        echo "
          /* Remove padding from sidebar title */
          .custom-sidebar-titlebar .sidebar .composite.title {
            padding-left: 0;
          }
          /* Make room for the traffic lights */
          .custom-activitybar div.monaco-workbench div.activitybar>div.content {
            margin-top: var(--titlebar-height);
          }
          /* Reset strange APC .activitybar styling back to VSCode defaults */
          .custom-activitybar div.monaco-workbench div.activitybar>div.content div.monaco-action-bar ul.actions-container li.action-item .badge div.badge-content {
            top: 24px;
            right: 8px;
          }
          .custom-activitybar div.monaco-workbench div.activitybar>div.content div.monaco-action-bar ul.actions-container li.action-item a.action-label {
            width: 48px;
            height: 48px;
            font-size: 24px;
            margin: 0 auto;
            mask-size: 1em;
            -webkit-mask-size: 1em;
          }
          .custom-activitybar div.monaco-workbench div.activitybar>div.content div.monaco-action-bar ul.actions-container li.action-item {
            margin-top: 0 !important;
          }
          /* Don't indent the status bar items */
          .monaco-workbench .part.statusbar>.items-container>.statusbar-item.left.first-visible-item {
            padding-left: 0;
          }
          /* Show the host button again and make it as wide as the .activitybar */
          .statusbar #status\.host {
            display: block !important;
            width: calc(var(--activity-bar-action-size) - 1px);
          }
          .statusbar #status\.host .codicon {
            margin: 0 auto;
          }
          /* Make squiggly error, hint, info, and warning rounded */
          .monaco-editor .squiggly-error::before,
          .monaco-editor .squiggly-hint::before,
          .monaco-editor .squiggly-info::before,
          .monaco-editor .squiggly-warning::before {
            border-radius: 3px !important;
            padding: 0px 1px 0px 1px !important;
            transform: translate(-1px, 0px);
          }
          .monaco-editor .squiggly-error,
          .monaco-editor .squiggly-hint,
          .monaco-editor .squiggly-info,
          .monaco-editor .squiggly-warning {
            background: none !important;
          }
          /* Make all highlights round */
          .selectionHighlight,
          .wordHighlightText {
            border-radius: 3px !important;
          }
        " >> "$out/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/workbench.desktop.main.css"
      '';
    }
  );
}
