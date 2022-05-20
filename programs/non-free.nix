{ lib, ... }:
{
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "1password"
        "1password-cli"
        "vscode"
        "vscode-with-extensions"        
    ];
}