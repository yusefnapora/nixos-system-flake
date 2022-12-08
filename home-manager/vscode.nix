{ config, system, nixosConfig ? {}, darwinConfig ? {}, lib, pkgs, ... }:
let
  inherit (lib) mkIf lists;

  systemConfig = nixosConfig // darwinConfig;
  guiEnabled = systemConfig.yusef.gui.enable;

  home.packages = with pkgs; [ rust-analyzer ];

  extensions = (with pkgs.vscode-extensions; [
    bbenoist.nix
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-ssh
    github.vscode-pull-request-github
    skyapps.fish-vscode
    rust-lang.rust-analyzer
    golang.go
    denoland.vscode-deno
    jnoortheen.nix-ide
    tamasfe.even-better-toml
    yzhang.markdown-all-in-one
    mhutchie.git-graph
  ]) 
  ++ lists.optionals (system == "x86_64-linux") (with pkgs.vscode-extensions; [
    ms-vsliveshare.vsliveshare
    ms-vscode.cpptools
  ])
  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    { # helix-like keybindings
      name = "dancehelix";
      publisher = "silverquark";
      version = "0.5.16";
      sha256 = "sha256-oHwtlbB18ctEnfStDOpJ+2/Kq41JZog8FVhTa1/s7m0=";
    }
    { # spacemacs color theme
      name = "spacemacs";
      publisher = "rkwan94";
      version = "0.0.2";
      sha256 = "094d4ae114bd3479014cd4517570cd446e4333e34bc859642a0d28ddefa06a7e";
    }

    { # vscode remote containers
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.248.0";
      sha256 = "sha256-Q3bnxByJkTXn/cQZWQsjlohhvPI16dsD56WthVJl8JA=";
    }

    { # standard-js code style
      name = "vscode-standard";
      publisher = "standard";
      version = "2.1.0";
      sha256 = "f329e5097cd31b7823d006a659bb2da098b1b1b7c6a8affec869036ed5a5d601";
    }

    { # nand2tetris
      name = "nand2tetris";
      publisher= "leafvmaple";
      version = "1.1.1";
      sha256 = "sha256-vfsVvXnW+LuUL93D07lHGlsOrGlMrwxoIJfQ9Ec0k38=";
    }

    { # svelte
      name = "svelte-vscode";
      publisher = "svelte";
      version = "105.20.0";
      sha256 = "sha256-+vYNgKVuknPROKTMMHugc9VrvYZ7GONr5SgYsb7l5rs=";
    }

    { # dagger (ci thing, uses CUE lang)
      name = "dagger";
      publisher = "Dagger";
      version = "0.3.3";
      sha256 = "sha256-53WN/6TSgSqiKZ+cG0U7oSyo4H3etRQihLhZ0H14a6k=";
    }

#    { # marp (markdown presentation thing)
#      name = "marp-vscode";
#      publisher = "marp-team";
#      version = "2.3.0";
#      sha256 = "sha256-sQdzMTZA0ZCwzU/+r2f88qIHBjj+Qvlrsa92bGbx2XA=";
#    }

    { # nushell
      name = "vscode-nushell-lang";
      publisher = "TheNuProjectContributors";
      version = "0.7.0";
      sha256 = "sha256-+AGJkFx/uzgQzuRnRBZ44xGNQ6a/QWt7SNiQgwPTZxo=";
    }

    { # Storyteller (code walkthrough thing: https://markm208.github.io/)
      name = "storyteller";
      publisher = "markm208";
      version = "1.1.0";
      sha256 = "sha256-y51Hpo6m/G6ZSRlU4go3Q+la2+uVEcmm1zRodsphgws=";
    }

    { # Vue
      name = "volar";
      publisher = "Vue";
      version = "1.0.11";
      sha256 = "sha256-8WTYrg2PcTR/824KZJXvmHamwI1kf2I8d3qgA2NjlQ0=";
    }
  ];

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
  ];

  defaultTheme = "Spacemacs";
in
{
  config = mkIf (guiEnabled) {
    programs.vscode = {
      enable = true;

      inherit extensions;

      userSettings = {
        # disable auto-update notifications
        "update.mode" = "none";

        # hide menu bar, show with alt
        "window.menuBarVisibility" = "toggle";
        
        "editor.accessibilitySupport" = "off";
        
        # fix server path for rust-analyzer plugin
        "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";

        # workaround timeout issue when connecting to vscode server running on nixos
        "remote.SSH.useLocalServer" = false;

        "workbench.colorTheme" = "${defaultTheme}";

        "editor.tabSize" = 2;
        "editor.fontFamily" = "'Fira Code'";
        "editor.fontSize" = 16;
        "editor.fontWeight" = 450;
        "editor.fontLigatures" = true;

        "terminal.integrated.fontFamily" = "Fira Mono for Powerline";
        "terminal.integrated.fontSize" = 16;
        "terminal.integrated.fontWeight" = 450;

        # Use markdown-all-in-one as default formatter
        "[markdown]" = {
          "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        };

        # disable markdown-all-in-one's TOC auto-update
        "markdown.extension.toc.updateOnSave" = false;

        # Svelte typescript integration
        "svelte.plugin.svelte.useNewTransformation" = true;
       
        # don't highlight comments as errors in JSON files
        "files.associations" = {
          "*.json" = "jsonc";
        };
      }; 
    };
  };
}