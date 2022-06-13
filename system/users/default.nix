{ config, pkgs, ... }:
{
    users.users.yusef = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "onepassword" ];
        shell = pkgs.fish;

        openssh.authorizedKeys.keys = [ 
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII280YRFMNNpVO7qxroCmuodMY5Hzo4UwTPoXuukU4tW"
        ];
    };

    users.users.root.openssh.authorizedKeys.keys =
      config.users.users.yusef.openssh.authorizedKeys.keys;

    # allow running nixos-rebuild as root without a password.
    # requires us to explicitly pull in nixos-rebuild from pkgs, so
    # we get the right path in the sudo config
    environment.systemPackages = [ pkgs.nixos-rebuild ];
    security.sudo.extraRules = [
        {  users = [ "yusef" ];
            commands = [
            { command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild" ;
                options= [ "NOPASSWD" "SETENV" ];
            }
            ];
        }
    ];
}