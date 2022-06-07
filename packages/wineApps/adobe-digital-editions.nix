{ pkgs, ...}:
let
  source = builtins.fetchurl {
      url = "http://download.adobe.com/pub/adobe/digitaleditions/ADE_2.0_Installer.exe";
      sha256 = "d9938f005a629347b431fe9e576739576625a7b745328dbd5617b57fc31ae823";
  };

  bin = pkgs.wrapWine {
    name = "ade";
    executable = "$WINEPREFIX/drive_c/Program Files/Adobe/'Adobe Digital Editions 2.0'/DigitalEditions.exe";
    setupScript = ''
    wine ${source} /S
    '';
  };

  desktop = pkgs.makeDesktopItem {
      name = "ADE";
      desktopName = "Adobe Digital Editions";
      type = "Application";
      exec = "${bin}/bin/ade";
  };
in pkgs.symlinkJoin {
    name = "adobe-desktop-edition";
    paths = [ bin desktop ];
}