local wk = require("which-key")
wk.setup({ preset = "modern" })
wk.add({
  { "<leader>f", group = "find" },
  { "<leader>l", group = "lsp" },
  { "<leader>d", group = "debug" },
  { "<leader>g", group = "git" },
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code/quickfix" },
  { "<leader>x", group = "trouble" },
  { "<leader>t", group = "terminal" },
})
