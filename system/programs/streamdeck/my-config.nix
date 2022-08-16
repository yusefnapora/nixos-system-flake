# my personal streamdeck configuration
# as a nix attribute set. see ./settings.nix for parsing logic
# todo: figure out a better place to put this

{ pkgs, lib, ... }:
let
  icons = (import ./icons);
  scripts = (import ./scripts { inherit pkgs; inherit lib; });

  inherit (scripts) activate-window-by-name type-in-window;

  obs-password = "donthackmebro"; # TODO: setup secrets, ala https://xeiaso.net/blog/nixos-encrypted-secrets-2021-01-20 
  obs-cli = "${pkgs.yusef.obs-cli}/bin/obs-cli --password ${obs-password}";
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

        { button = 5;
          # text = "OBS";
          switch-page = 2;
          icon = "${icons.obs}";
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

    # OBS controls page
    { page = 2;
      buttons = [
        { button = 0;
          text = "Toggle Rec";
          icon = "${icons.record}";
          command = "${obs-cli} recording toggle";
        }
        { button = 1;
          # text = "Play/Pause";
          icon = "${icons.play-pause}";
          command = "${obs-cli} recording pause toggle";
        }

        { button = 5;
          # text = "Back";
          icon = "${icons.back-arrow}";
          switch-page = 0;
        }

        { button = 10;
          text = "Screen";
          icon = "${icons.window}";
          command = "${obs-cli} scene switch 'Desktop Capture'";
        }

        { button = 11;
          text = "Camera";
          icon = "${icons.selfie}";
          command = "${obs-cli} scene switch 'Camera Only'";
        }

        { button = 12; 
          text = "Screen+Cam";
          icon = "${icons.window-and-selfie}";
          command = "${obs-cli} scene switch 'Desktop Capture With Camera'";
        }
      ];
    }
  ];
}