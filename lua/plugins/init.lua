-- Packer bootstrap + the full plugin list.
-- Every non-trivial plugin's settings live in its own file under lua/plugins/.

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local bootstrapped = false

if fn.empty(fn.glob(install_path)) > 0 then
  bootstrapped = true
  print("Cloning packer.nvim ...")
  fn.system({
    "git", "clone", "--depth", "1",
    "https://github.com/wbthomason/packer.nvim", install_path,
  })
  vim.cmd("packadd packer.nvim")
end

local ok, packer = pcall(require, "packer")
if not ok then return end

-- Recompile automatically when any plugin file changes
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("PackerCompile", { clear = true }),
  pattern = vim.fn.stdpath("config") .. "/lua/plugins/*.lua",
  command = "source <afile> | PackerCompile",
})

packer.init({
  compile_path = fn.stdpath("data") .. "/site/plugin/packer_compiled.lua",
  display = {
    open_fn = function() return require("packer.util").float({ border = "rounded" }) end,
  },
  git = { clone_timeout = 300 },
  max_jobs = 8,
})

-- NOTE: packer compiles `config` into packer_compiled.lua. Function values are
-- serialised with string.dump(), which DROPS UPVALUES -- so a closure like
-- `function() require("plugins." .. name) end` breaks with "attempt to
-- concatenate upvalue (a nil value)". The string form is loadstring()'d at
-- runtime and is safe.
local function cfg(name)
  return string.format("require('plugins.%s')", name)
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")

  -- Libraries
  use("nvim-lua/plenary.nvim")
  use({ "nvim-tree/nvim-web-devicons", config = cfg("icons") })
  use({ "MunifTanjim/nui.nvim" })

  ---------------------------------------------------------------- appearance
  -- Emacs-derived colorschemes; lua/plugins/colorscheme.lua picks between them
  use({ "miikanissi/modus-themes.nvim", config = cfg("colorscheme") })
  use("NTBBloodbath/doom-one.nvim")
  use("phha/zenburn.nvim")
  use("oonamo/ef-themes.nvim")
  use({ "nvim-lualine/lualine.nvim", config = cfg("lualine") })
  use({ "akinsho/bufferline.nvim", tag = "*", config = cfg("bufferline") })
  use({ "lukas-reineke/indent-blankline.nvim", main = "ibl", config = cfg("indent") })
  use({ "folke/todo-comments.nvim", config = cfg("todo") })
  use({ "j-hui/fidget.nvim", config = cfg("fidget") })

  ---------------------------------------------------------------- treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    branch = "master",          -- pinned: the `main` branch has a different API
    run = ":TSUpdate",
    config = cfg("treesitter"),
  })
  -- NOTE: no `after = "nvim-treesitter"` here. `after` makes packer install
  -- these as *opt* plugins loaded only once treesitter finishes, which is
  -- strictly too late -- treesitter's own config runs first and would not
  -- see them. As start plugins they are all on the rtp before any config runs.
  use({ "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" })
  use({ "windwp/nvim-ts-autotag", config = cfg("autotag") })

  ---------------------------------------------------------------- navigation
  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = { "nvim-lua/plenary.nvim" },
    config = cfg("telescope"),
  })
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("nvim-telescope/telescope-ui-select.nvim")
  use({ "nvim-tree/nvim-tree.lua", config = cfg("nvim-tree") })
  use({ "stevearc/oil.nvim", config = cfg("oil") })
  use({ "folke/flash.nvim", config = cfg("flash") })
  use({ "folke/which-key.nvim", config = cfg("which-key") })

  ---------------------------------------------------------------------- lsp
  use("neovim/nvim-lspconfig")          -- provides default cmd/root_markers
  use({ "mason-org/mason.nvim", config = cfg("mason") })
  use("mfussenegger/nvim-jdtls")        -- Java, driven from after/ftplugin/java.lua
  use({ "folke/trouble.nvim", config = cfg("trouble") })
  use({ "stevearc/conform.nvim", config = cfg("conform") })
  use({ "mfussenegger/nvim-lint", config = cfg("lint") })

  --------------------------------------------------------------- completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      { "L3MON4D3/LuaSnip", run = "make install_jsregexp" },
      "rafamadriz/friendly-snippets",
    },
    config = cfg("cmp"),
  })

  -------------------------------------------------------------------- debug
  use({
    "mfussenegger/nvim-dap",
    requires = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "leoluz/nvim-dap-go",
    },
    config = cfg("dap"),
  })

  ---------------------------------------------------------------- git / qol
  use({ "lewis6991/gitsigns.nvim", config = cfg("gitsigns") })
  -- Fugitive is vimscript with no setup() call and no deps; keymaps and the
  -- conflict-resolution helpers live in lua/plugins/fugitive.lua.
  use({ "tpope/vim-fugitive", config = cfg("fugitive") })
  use("tpope/vim-rhubarb")   -- :GBrowse -> open current line on GitHub
  use({ "numToStr/Comment.nvim", config = cfg("comment") })
  use({ "windwp/nvim-autopairs", config = cfg("autopairs") })
  use({ "kylechui/nvim-surround", tag = "*", config = cfg("surround") })
  use({ "akinsho/toggleterm.nvim", tag = "*", config = cfg("toggleterm") })
  use({ "stevearc/quicker.nvim", config = cfg("quicker") })

  if bootstrapped then
    packer.sync()
  end
end)
