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

  brightness = 40;
  brightness-dimmed = 4;
  display-timeout = 900;

  pages = [
    { page = 0;
      buttons = [
        { button = 0;
          # text = "Zoom";
          switch-page = 1;
          command = "${activate-window-by-name} 'Zoom Meeting'";
          icon = "${icons.zoom}";
        }
        { button = 1;
          # text = "Firefox";
          command = "${activate-window-by-name} '.*Mozilla Firefox$' firefox";
          icon = "${icons.firefox}";
        }
        { button = 2;
          # text = "Slack";
          command = "${activate-window-by-name} 'Slack \\|.*' slack";
          icon = "${icons.slack}";
        }
        { button = 3;
          # text = "VSCode";
          command = "${activate-window-by-name} '.*Visual Studio Code' code";
          icon = "${icons.vscode}";
        }


      ];
    }

    # Zoom controls page
    { page = 1;
      buttons = [
        { button = 0;
          # text = "Back";
          icon = "${icons.back-arrow}";
          switch-page = 0;
        }
        { button = 1;
          text = "Zoom cam";
          command = "${type-in-window} 'Zoom Meeting' 'alt+v' --activate";
          icon = "${icons.video-off}";
        }
        { button = 2;
          text = "Zoom mic";
          command = "${type-in-window} 'Zoom Meeting' 'alt+a' --activate";
          icon = "${icons.mic-off}";
        }
        { button = 3;
          text = "Screenshare";
          command = "${type-in-window} 'Zoom Meeting' 'alt+s' --activate";
          icon = "${icons.screen-share}";
        }

        { button = 5;
          text = "Focus";
          switch-page = 1;
          command = "${activate-window-by-name} 'Zoom Meeting'";
          icon = "${icons.zoom}";
        }

      ];
    }
  ];
}