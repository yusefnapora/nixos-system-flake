{ ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent=yes
    '';

    matchBlocks = {
      sb = {
        hostname = "deneb.usbx.me";
        user = "yusef";
      };
    };
  };
}