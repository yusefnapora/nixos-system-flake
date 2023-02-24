{ lib, pkgs, nixvim, ...}:
{

  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;

    globals = {
      mapleader = ";";
      rust_recommended_style = false;
    };

    options = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
    };

    maps = {
      normal = {
        # move between split panes with ctrl+ movement keys, without Ctrl+W prefix first
        "<C-J>" = "<C-W><C-J>";
        "<C-H>" = "<C-W><C-H>";
        "<C-K>" = "<C-W><C-K>";
        "<C-L>" = "<C-W><C-L>";
      };
    };

    plugins = {
      airline = {
        enable = true;
        powerline = true;
        theme = "powerlineish";
      };

      packer = {
        enable = true;
        plugins = [
          { name = "ldelossa/nvim-ide";
            config = (builtins.readFile ./ide-setup.lua);
          }
        ];
      };

      barbar.enable = true;
      rust-tools.enable = true;
      nix.enable = true;
      nvim-cmp = {
        enable = true;
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      lsp = {
        enable = true;

        servers = {
          jsonls.enable = true;
          rust-analyzer.enable = true;
          rnix-lsp.enable = true;
        };
      };
    };

  };
}
