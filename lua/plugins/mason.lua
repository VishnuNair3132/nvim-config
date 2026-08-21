-- Put Mason's bin dir on PATH so conform, nvim-lint and dap can find the
-- binaries it installs without any extra per-tool configuration.
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

require("mason").setup({
  ui = { border = "rounded", icons = { package_installed = require("core.icons").ui.check, package_pending = require("core.icons").ui.arrow, package_uninstalled = require("core.icons").ui.cross } },
})

-- Servers/tools this config expects. Install them with:
--   :MasonInstall clangd gopls typescript-language-server jdtls lua-language-server ...
-- or run :InstallTools (defined below) once after first launch.
local tools = {
  -- LSP
  "clangd", "gopls", "typescript-language-server", "jdtls",
  "lua-language-server", "eslint-lsp",
  -- DAP
  "codelldb", "delve", "js-debug-adapter", "java-debug-adapter", "java-test",
  -- format / lint
  "clang-format", "gofumpt", "goimports", "prettierd", "google-java-format",
  "stylua", "shfmt", "eslint_d",
}

vim.api.nvim_create_user_command("InstallTools", function()
  vim.cmd("MasonInstall " .. table.concat(tools, " "))
end, { desc = "Install every LSP/DAP/formatter this config uses" })

vim.keymap.set("n", "<leader>lm", "<cmd>Mason<CR>", { desc = "Mason" })
