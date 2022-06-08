{ config, pkgs, ... }:
{

  # enable sway (Wayland i3 thing)
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      # SDL:
      export SDL_VIDEODRIVER=wayland
      # QT (needs qt5.qtwayland in systemPackages):
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

}