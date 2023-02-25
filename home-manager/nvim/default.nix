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

        # toggle nvim-ide panels
        "<leader>tr" = "<cmd>Workspace RightPanelToggle<CR>";
        "<leader>tl" = "<cmd>Workspace LeftPanelToggle<CR>";

        # focus the nvim-ide explorer panel
        "<C-\\>" = "<cmd>Workspace Explorer Focus<CR>";
      };
    };

    plugins = {
      airline = {
        enable = true;
        powerline = true;
        theme = "deus";
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
        mapping = let 
          if-visible = (action: ''
            function(fallback)
              if cmp.visible() then
                ${action}
              else
                fallback()
              end
            end
          '');
          select-next = {
            modes = [ "i" "s" "c" ];
            action = if-visible "cmp.select_next_item()";
          };
          select-prev = {
            modes = [ "i" "s" "c" ];
            action = if-visible "cmp.select_prev_item()";
          };
          scroll-next = {
            modes = [ "i" "s" "c" ];
            action = if-visible "cmp.scroll_docs(4)"; 
          };
          scroll-prev = { 
            modes = [ "i" "s" "c" ];
            action = if-visible "cmp.scroll_docs(-4)"; 
          };
        in {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = select-next;
          "<C-n>" = select-next;
          "<Down>" = select-next;
          "<C-p>" = select-prev;
          "<Up>" = select-prev;

          # scroll inside the popup view
          "<C-Up>" = scroll-prev;
          "<C-b>" = scroll-prev;
          "<C-Down>" = scroll-next;
          "<C-f>" = scroll-next;
        };
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
