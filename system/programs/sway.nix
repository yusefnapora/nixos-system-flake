# modified from https://github.com/Xe/nixos-configs/blob/0624176ee2d30c4c778730216f5bddc704ff2f24/common/programs/sway.nix
{ config, pkgs, lib, ... }:

with lib;
let cfg = config.yusef.sway;
in {
  options.yusef.sway = {
    enable = mkEnableOption "sway";
    i3status = mkEnableOption "use i3status?";
    output = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      example = { "HDMI-A-2" = { bg = "~/path/to/background.png fill"; }; };
      description = ''
        An attribute set that defines output modules. See man sway_output for options.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wdisplays ];
    programs.sway.enable = true;

    nixpkgs.overlays = [
      (self: super: {
        wl-clipboard-x11 = super.stdenv.mkDerivation rec {
          pname = "wl-clipboard-x11";
          version = "5";

          src = super.fetchFromGitHub {
            owner = "brunelli";
            repo = "wl-clipboard-x11";
            rev = "v${version}";
            sha256 = "1y7jv7rps0sdzmm859wn2l8q4pg2x35smcrm7mbfxn5vrga0bslb";
          };

          dontBuild = true;
          dontConfigure = true;
          propagatedBuildInputs = [ super.wl-clipboard ];
          makeFlags = [ "PREFIX=$(out)" ];
        };

        xsel = self.wl-clipboard-x11;
        xclip = self.wl-clipboard-x11;
      })
    ];
  };
}