# Package for Kindle v1.17, the last version before KFX downloads were added.
{ pkgs, fetchurl, makeDesktopItem, symlinkJoin, ... }:
let
  source = fetchurl {
    url = "https://ia600909.us.archive.org/6/items/kindle-for-pc-1-17-44170/kindle-for-pc-1-17-44170.exe";
    sha256 = "001j2r2024icfr8nk6z9pxzp0krlf30jv2a6qk3w0xhj7w2z1q0l";
  };

  name = "kindle";

  bin = pkgs.yusef.wrapWine {
    inherit name;

    firstrunScript = ''
      wine ${source} /S

      # create the default content folder 
      mkdir -p "$WINE_NIX_PROFILES/${name}/Documents/My Kindle Content"
    '';

    setupScript = ''
      # disable auto update
      APP_DIR="$WINE_NIX_PROFILES/${name}/AppData/Local/Amazon/Kindle"
      mkdir -p "$APP_DIR"
      echo "no thanks" > "$APP_DIR/updates"
    '';

    executable = "$WINEPREFIX/drive_c/Program Files/Amazon/Kindle/Kindle.exe";
  };

  desktop = makeDesktopItem {
    name = "Kindle";
    desktopName = "Kindle";
    type = "Application";
    exec = "${bin}/bin/kindle";
    icon = fetchurl {
      url = "https://m.media-amazon.com/images/I/51NEb1QMCHL.png";
      sha256 = "0jk028paxfgxb3hwkn8igbzx7a7a3aqywz5v2spx920mqdc11bg1";
    };
  };
in symlinkJoin {
  name = "kindle";
  paths = [bin desktop];
}
