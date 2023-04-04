{ config, system, nixosConfig ? {}, darwinConfig ? {}, lib, pkgs, ... }:
let
  inherit (lib) mkIf lists;
  inherit (pkgs.stdenv) isDarwin isLinux;

  systemConfig = nixosConfig // darwinConfig;
  guiEnabled = systemConfig.yusef.gui.enable;

  home.packages = [ pkgs.rust-analyzer ];

  colors = config.colorScheme.colors;




  ext = pkgs.vscode-extensions;

  extensions = [
    ext.bbenoist.nix
    ext.ms-azuretools.vscode-docker
    ext.ms-vscode-remote.remote-ssh
    ext.github.vscode-pull-request-github
    ext.skyapps.fish-vscode
    ext.rust-lang.rust-analyzer
    ext.golang.go
    ext.denoland.vscode-deno
    ext.jnoortheen.nix-ide
    ext.tamasfe.even-better-toml
    ext.yzhang.markdown-all-in-one
    ext.mhutchie.git-graph
    ext.vscodevim.vim
    ext.dbaeumer.vscode-eslint
    ext.esbenp.prettier-vscode
    ext.humao.rest-client
    ext.ms-dotnettools.csharp
  ]
  ++ lists.optionals (system == "x86_64-linux") [
    ext.ms-vsliveshare.vsliveshare
    ext.ms-python.python # currently broken on darwin & unsupported on aarch64-linux :(
    ext.ms-vscode.cpptools
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

    { # nushell
      name = "vscode-nushell-lang";
      publisher = "TheNuProjectContributors";
      version = "0.7.0";
      sha256 = "sha256-+AGJkFx/uzgQzuRnRBZ44xGNQ6a/QWt7SNiQgwPTZxo=";
    }

    { # nim
      name = "nimvscode";
      publisher = "nimsaem";
      version = "0.1.26";
      sha256 = "sha256-unxcnQR2ccsydVG3H13e+xYRnW+3/ArIuBt0HlCLKio=";
    }
    { # markdownlint
      name = "vscode-markdownlint";
      publisher = "DavidAnson";
      version = "0.49.0";
      sha256 = "sha256-Mh/OoRK410aXEr3sK2CYFDsXGSqFT+JOWi9jHOdK01Y=";
    }
    { # terraform
      name = "terraform";
      publisher = "4ops";
      version = "0.2.5";
      sha256 = "sha256-y5LljxK8V9Fir9EoG8g9N735gISrlMg3czN21qF/KjI=";
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
  ] ++ lists.optionals isDarwin [
    {
      key = "ctrl+s";
      command = "workbench.action.files.save";
    }
  ];

  defaultTheme = "Spacemacs";
in
{
  config = mkIf (guiEnabled) {
    programs.vscode = {
      enable = true;

      inherit extensions keybindings;

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

        # set the os for some remote hosts I use
        "remote.SSH.remotePlatform" = {
          "hex-wsl" =  "linux";
          "hex-win" = "windows";
          "nasty.lan" =  "linux";
          "asahi.lan" = "linux";
          "sef-macbook.lan" = "macOS";
        };

        # "workbench.colorTheme" = "${defaultTheme}";

        "workbench.colorCustomizations" = with colors; {
          "terminal.background" = "#${base00}";
          "terminal.foreground" = "#${base05}";
          "terminalCursor.background" = "#${base05}";
          "terminalCursor.foreground" = "#${base05}";
          "terminal.ansiBlack" = "#${base00}";
          "terminal.ansiBlue" = "#${base0D}";
          "terminal.ansiBrightBlack" = "#${base03}";
          "terminal.ansiBrightBlue" = "#${base0D}";
          "terminal.ansiBrightCyan" = "#${base0C}";
          "terminal.ansiBrightGreen" = "#${base0B}";
          "terminal.ansiBrightMagenta" = "#${base0E}";
          "terminal.ansiBrightRed" = "#${base08}";
          "terminal.ansiBrightWhite" = "#${base07}";
          "terminal.ansiBrightYellow" = "#${base0A}";
          "terminal.ansiCyan" = "#${base0C}";
          "terminal.ansiGreen" = "#${base0B}";
          "terminal.ansiMagenta" = "#${base0E}";
          "terminal.ansiRed" = "#${base08}";
          "terminal.ansiWhite" = "#${base05}";
          "terminal.ansiYellow" = "#${base0A}";
        };

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

        # svelte
        "svelte.ask-to-enable-ts-plugin" = false;
        "svelte.enable-ts-plugin" = true;

        # vim 
        "vim.useSystemClipboard" = true;

        # spellcheck ignore list
        "spellchecker.ignoreWordsList" = [
          "Yusef"
          "Yusef's"
          "Napora"
          "Blog"
          "blog"
          "html"
        ];
      }; 
    };
  };
}
