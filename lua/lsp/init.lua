-- Neovim 0.11+ native LSP wiring.
--
--   <config>/lsp/<name>.lua   -> the server definition (cmd, filetypes, settings)
--   vim.lsp.enable("<name>")  -> turns it on; Neovim finds the file above
--
-- nvim-lspconfig is installed only to supply sane defaults (cmd/root_markers)
-- that our own lsp/*.lua files are merged on top of.

require("lsp.diagnostics")
require("lsp.attach")

-- Shared capabilities for every server (adds nvim-cmp's extra completion caps)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
end
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { ".git" },
})

-- Java is intentionally absent: jdtls needs per-project workspaces, so it is
-- started by nvim-jdtls from after/ftplugin/java.lua instead.
vim.lsp.enable({
  "clangd",   -- c, cpp
  "gopls",    -- go
  "ts_ls",    -- javascript, typescript
  "eslint",   -- js/ts linting via LSP
  "lua_ls",   -- for editing this config
})
