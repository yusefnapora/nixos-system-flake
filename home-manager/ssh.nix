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

      # oracle cloud vm
      pythia = {
        hostname = "129.153.147.95";
      };
    };
  };
}