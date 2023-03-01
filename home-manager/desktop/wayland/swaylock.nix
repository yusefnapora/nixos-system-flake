{ config, pkgs, ... }:
{
  home.packages = [ pkgs.swaylock-effects ];
  programs.swaylock.settings = {
    effect-blur = "20x3";
    fade-in = 0.1;

    font = config.fontProfiles.regular.family;
    font-size = 15;

    line-uses-inside = true;
    disable-caps-lock-text = true;
    indicator-caps-lock = true;
    indicator-radius = 40;
    indicator-idle-visible = true;

    # TODO: colors
  };
}
