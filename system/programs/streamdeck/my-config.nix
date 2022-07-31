# my personal streamdeck configuration
# as a nix attribute set. see ./settings.nix for parsing logic
# todo: figure out a better place to put this

{ pkgs, lib, ... }:
let
  icons = (import ./icons);
  scripts = (import ./scripts { inherit pkgs; inherit lib; });

  inherit (scripts) activate-window-by-name type-in-window; 
in
{
  device-id = "DL51K1A63326";
  num-buttons = 15;

  pages = [
    { page = 0;
      buttons = [
        { button = 0;
          text = "Firefox";
          command = "${activate-window-by-name} '.*Mozilla Firefox$' firefox";
          icon = "${icons.firefox}";
        }
        { button = 5;
          text = "Slack";
          command = "${activate-window-by-name} 'Slack \\|.*' slack";
          icon = "${icons.slack}";
        }
        { button = 10;
          text = "VSCode";
          command = "${activate-window-by-name} '.*Visual Studio Code' code";
          icon = "${icons.vscode}";
        }
      ];
    }
  ];
}