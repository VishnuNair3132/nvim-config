-- ESLint via LSP (code actions + fix-on-save). Install: :MasonInstall eslint-lsp
-- Only starts when the project actually has an eslint config.
return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte",
  },
  root_markers = {
    "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
    ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yaml",
  },
  settings = {
    workingDirectories = { mode = "auto" },
    format = false, -- prettier handles formatting
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
}
