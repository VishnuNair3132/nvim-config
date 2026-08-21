local icons = require("core.icons").diagnostics

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true, header = "", prefix = "" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.ERROR,
      [vim.diagnostic.severity.WARN]  = icons.WARN,
      [vim.diagnostic.severity.INFO]  = icons.INFO,
      [vim.diagnostic.severity.HINT]  = icons.HINT,
    },
  },
})

local map = vim.keymap.set
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })

vim.api.nvim_create_user_command("DiagnosticsToggle", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
