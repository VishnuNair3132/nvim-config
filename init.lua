-- ~/.config/nvim/init.lua
-- Entry point. Keep this file boring; everything real lives in lua/.

if vim.fn.has("nvim-0.11") == 0 then
  vim.notify("This config needs Neovim 0.11+ (native vim.lsp.config)", vim.log.levels.ERROR)
  return
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core")     -- options, keymaps, autocmds
require("plugins")  -- packer bootstrap + plugin specs
require("lsp")      -- diagnostics, LspAttach keymaps, vim.lsp.enable(...)
require("custom")   -- your own stuff, loaded last so it can override
