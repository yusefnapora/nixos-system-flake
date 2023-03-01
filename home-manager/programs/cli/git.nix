{ config, pkgs, ... }:
{
    programs.git = { 
        enable = true;
        userName = "Yusef Napora";
        userEmail = "yusef@napora.org";
        aliases = {
            upstream-name = "!git remote | egrep -o '(upstream|origin)' | tail -1";
            head-branch = "!basename $(git symbolic-ref refs/remotes/$(git upstream-name)/HEAD)";
            cm = "!git checkout $(git head-branch)";
            co = "checkout";
        };

        ignores = [
            ".env"
            ".envrc"
            ".direnv/"
            "*.swp"
            ".idea/"
        ];

        extraConfig = {
            init.defaultBranch = "main";
        };

        difftastic = { 
          enable = true;
          background = "dark"; 
        };
    };
}