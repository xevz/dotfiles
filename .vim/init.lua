--
-- Bootstrap lazy.nvim if not already installed
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
--
-- End bootstrap lazy.nvim
--

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.autoindent = true
vim.o.cindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

vim.o.backspace = "indent,eol,start"

vim.o.number = true
vim.o.ruler = true

-- vim.o.background = "dark"

vim.o.backup = false

vim.o.incsearch = false
vim.o.showmatch = true
vim.o.hlsearch = true

vim.o.laststatus = 2

vim.o.wildmenu = true
vim.o.wildmode = "list:longest,full"

vim.o.mouse = ""

require("lazy").setup({
  spec = {
    { "shaunsingh/nord.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.g.nord_disable_background = true
        vim.cmd([[colorscheme nord]])
      end,
    },
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "VeryLazy",
      priority = 1000,
      config = function()
        require("tiny-inline-diagnostic").setup()
        vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      opts = {},
    },
    {
      "nvim-mini/mini.completion",
      event = "InsertEnter",
      opts = {},
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "ansiblels",
          "lua_ls",
          "rust_analyzer",
          "terraformls",
          "tflint",
          "yamlls",
        },
      },
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
      },
    },
    {
      "github/copilot.vim",
      event = "InsertEnter",
      config = function()
        vim.api.nvim_set_keymap('i', '<C-y>', 'copilot#Accept("")', {
          expr             = true,
          noremap          = true,
          silent           = true,
          replace_keycodes = false,
        })
      end,
    },
    {
      "hashivim/vim-terraform",
      ft = { "terraform", "tf" },
    },
  },

  -- colorscheme that will be used when installing plugins
  install = { colorscheme = { "nord" } },

  -- disable plugin update check
  checker = { enabled = false },
})

vim.g.copilot_no_tab_map = true

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        -- Make Lua LSP recognize 'vim' global
        globals = { "vim" }
      }
    }
  }
})
