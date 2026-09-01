{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      splitright = true;
      splitbelow = true;
      mouse = "a";
      clipboard = "unnamedplus";
      colorcolumn = "80";
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      rustfmt_autosave = 1;
      rustfmt_emit_files = 1;
      rustfmt_fail_silentrly = 0;
    };

    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      nvim-autopairs.enable = true;
      comment.enable = true;
      web-devicons.enable = true;
      colorizer.enable = true;

      indent-blankline = {
        enable = true;
        settings = {
          indent.char = "│";
          scope.enabled = false;
        };
      };

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "│";
          change.text = "│";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
          untracked.text = "┆";
        };
      };

      # --- Nix editing QOL ---
      # nixd: flake-aware LSP (resolves inputs/outputs, real completions/go-to-def)
      # nil_ls: complementary diagnostics, formats via nixfmt
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd.enable = true;
          nil_ls = {
            enable = true;
            settings.nil.formatting.command = [ "nixfmt" ];
          };
        };
      };

      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
          };
          sources = [
            {
              name = "nvim_lsp";
              priority = 1000;
            }
            {
              name = "buffer";
              priority = 500;
            }
            {
              name = "path";
              priority = 250;
            }
          ];
        };
      };
    };

    extraPackages = with pkgs; [
      nixfmt
    ];

    keymaps = [
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
        options.desc = "Show references";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "Hover info";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "Code action";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        options.desc = "Rename";
      }
    ];
  };
}
