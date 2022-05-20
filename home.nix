{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];


  home-manager.users.yusef = { 
    programs.home-manager.enable = true;
    
    programs.git = { 
      enable = true;
      userName = "Yusef Napora";
      userEmail = "yusef@napora.org";
    };

    programs.vscode = { 
      enable = true;
      extensions = with pkgs.vscode-extensions; [ 
        # yzhang.markdown-all-in-one
      ];
    };

  };
}
