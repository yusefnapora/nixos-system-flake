{ pkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs;
  inherit (lib) lists strings;
in
{
  imports = [
    ./common.nix
    ../options.nix
  ];


  # TODO: pull yabai config into module if we like it
  services.yabai = let
    unmanaged-apps = [
      "System Settings"
      "System Preferences"
      "Zoom"
      "zoom.us"
    ];
    app-rules = lists.forEach unmanaged-apps (app: 
      "yabai -m rule --add app='${app}' manage=off"
      );
    app-rules-str = strings.concatStringsSep "\n" app-rules;
  in {
    enable = true;
    config = {
      window_placement    = "second_child";
      window_opacity      = "off";
      window_shadow       = "float";
    };
    extraConfig = ''
      ${app-rules-str}
    '';
  };


  services.skhd = let
    hyper = "ctrl + cmd + alt";
    wezterm = "/Applications/WezTerm.app/Contents/MacOS/wezterm"; # bit of nix heresy.. but the verion of wezterm in nixpkgs is a little wonky, so I just run it from a global manual install ATM. TODO: maybe pull from homebrew (via nix)
    yabai = "${pkgs.yabai}/bin/yabai";
  in {
    enable = true;
    skhdConfig = ''
    ${hyper} - return : ${wezterm} start

    # focus next space, wrapping around to first space
    ${hyper} - tab : ${yabai} -m space --focus next || ${yabai} -m space --focus first

    # focus prev space, wrapping back to last space
    ${hyper} + shift - tab : ${yabai} -m space --focus prev || ${yabai} -m space --focus last

    # ${hyper} - tab : ${yabai} -m window --swap next
    # ${hyper} + shift - tab : ${yabai} -m window --swap prev

    ${hyper} - h : ${yabai} -m window --swap west
    ${hyper} - j : ${yabai} -m window --swap south
    ${hyper} - k : ${yabai} -m window --swap north
    ${hyper} - l : ${yabai} -m window --swap east
    '';
  };

  environment.systemPackages = [ pkgs.skhd ];

  system.stateVersion = 4;
}
