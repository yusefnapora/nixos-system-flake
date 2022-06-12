{ config, pkgs, ... }:
{
    users.users.yusef = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" ];
        shell = pkgs.fish;

        openssh.authorizedKeys.keys = [ 
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII280YRFMNNpVO7qxroCmuodMY5Hzo4UwTPoXuukU4tW"
        ];
    };

    users.users.root.openssh.authorizedKeys.keys =
      config.users.users.yusef.openssh.authorizedKeys.keys;
}