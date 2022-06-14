{ config, lib, pkgs, homeManagerFlags, ... }:
with lib;
let
  inherit (homeManagerFlags) system;
  guiEnabled = homeManagerFlags.withGUI;

  keybindings = [
    {
      key = "ctrl+a";
      command = "cursorHome";
      when = "textInputFocus";
    }

    {
      key = "ctrl+e";
      command = "cursorEnd";
      when = "textInputFocus";
    }

    {
      key = "ctrl+shift+u";
      command = "workbench.action.quickOpen";
      when = null;
    }

    # VSpaceCode
    # Trigger vspacecode in empty editor group
    {
        key = "space";
        command = "vspacecode.space";
        when = "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
    }
    # Trigger vspacecode when sidebar is in focus
    {
        key = "space";
        command = "vspacecode.space";
        when = "sideBarFocus && !inputFocus && !whichkeyActive";
    }
    # Easy navigation in quick open/QuickPick
    {
        key = "ctrl+j";
        command = "workbench.action.quickOpenSelectNext";
        when = "inQuickOpen";
    }
    {
        key = "ctrl+k";
        command = "workbench.action.quickOpenSelectPrevious";
        when = "inQuickOpen";
    }
    # Easy navigation in sugesstion/intellisense
    # Cannot be added to package.json because of conflict with vim's default bindings
    {
        key = "ctrl+j";
        command = "selectNextSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    {
        key = "ctrl+k";
        command = "selectPrevSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    {
        key = "ctrl+l";
        command = "acceptSelectedSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    #  Easy navigation in parameter hint (i.e. traverse the hints when there's multiple overload for one method)
    #  Cannot be added to package.json because of conflict with vim's default bindings
    {
        key = "ctrl+j";
        command = "showNextParameterHint";
        when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
    }
    {
        key = "ctrl+k";
        command = "showPrevParameterHint";
        when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
    }
    #  Easy navigation in parameter hint (i.e. traverse the hints when there's multiple overload for one method)
    # Cannot be added to package.json because of conflict with vim's default bindings
    {
        key = "ctrl+j";
        command = "showNextParameterHint";
        when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
    }
    {
        key = "ctrl+k";
        command = "showPrevParameterHint";
        when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
    }
  ];

  extensions = (with pkgs.vscode-extensions; [
    bbenoist.nix
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-ssh
    vscodevim.vim
    vspacecode.vspacecode
    vspacecode.whichkey
  ]) 
  ++ lists.optionals (system == "x86_64-linux") [
    ms-vsliveshare.vsliveshare
  ]
  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    { # spacemacs color theme
      name = "spacemacs";
      publisher = "rkwan94";
      version = "0.0.2";
      sha256 = "094d4ae114bd3479014cd4517570cd446e4333e34bc859642a0d28ddefa06a7e";
    }

    { # vscode remote containers
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.239.0";
      sha256 = "c967933a9ce8459faf275904275dda7808d7d45b476c2b8ca2af343e20b5c814";
    }
  ];
  
  defaultTheme = "Spacemacs";
in
{
  config = mkIf (guiEnabled) {
    programs.vscode = {
      enable = true;

      inherit extensions;

      userSettings = {
        "workbench.colorTheme" = "${defaultTheme}";

        "editor.fontFamily" = "'Fira Code'";
        "editor.fontSize" = 16;
        "editor.fontWeight" = 450;
        "editor.fontLigatures" = true;

        "terminal.integrated.fontFamily" = "Fira Mono for Powerline";
        "terminal.integrated.fontSize" = 16;
        "terminal.integrated.fontWeight" = 450;

        # I'm addicted to the macOS "emacs-like" shortcuts, but just ctrl-a and ctrl-e
        "vim.insertModeKeyBindings" = [
          {
            before = ["<C-a>"];
            after = ["Esc" "I"];
          }
          {
            before = ["<C-e>"];
            after = ["Esc" "A"];
          }
        ];

        # VSpaceCode settings
        "vim.easymotion" = true;
        "vim.useSystemClipboard" = true;
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = ["<space>"];
            commands = ["vspacecode.space"];
          }
          {
            before = [","];
            commands = [
              "vspacecode.space"
              {
                command = "whichkey.triggerKey";
                args = "m";
              }
            ];
          }
        ];
      "vim.visualModeKeyBindingsNonRecursive" = [
          {
            before = ["<space>"];
            commands = ["vspacecode.space"];
          }
          {
            before = [","];
            commands = [
              "vspacecode.space"
              {
                command = "whichkey.triggerKey";
                args = "m";
              }
            ];
          }
        ];
      }; 
    };
  };
}