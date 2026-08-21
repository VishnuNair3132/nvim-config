local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    java = { "google-java-format" },
    go = { "goimports", "gofumpt" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    lua = { "stylua" },
    sh = { "shfmt" },
    ["_"] = { "trim_whitespace" },
  },
  default_format_opts = { lsp_format = "fallback" },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
    return { timeout_ms = 2000, lsp_format = "fallback" }
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer/selection" })

vim.api.nvim_create_user_command("FormatToggle", function(args)
  if args.bang then
    vim.b.disable_autoformat = not vim.b.disable_autoformat
  else
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  end
  print("format on save: " .. tostring(not (vim.g.disable_autoformat or vim.b.disable_autoformat)))
end, { bang = true, desc = "Toggle format-on-save (! = buffer only)" })
