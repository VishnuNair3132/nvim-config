local lint = require("lint")

lint.linters_by_ft = {
  javascript      = { "eslint_d" },
  typescript      = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  sh              = { "shellcheck" },
}

-- nvim-lint raises if the linter binary is missing, which happens on every
-- JS/TS buffer until `:InstallTools` has run. Only run linters we can actually
-- find on PATH (or in Mason's bin dir), and never let one break BufReadPost.
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

local function available(name)
  -- A linter's `cmd` may be a string, a function, or the module may not resolve
  -- at all; fall back to the linter's own name in any of those cases.
  local cmd = name
  local ok, linter = pcall(function() return lint.linters[name] end)
  if ok and type(linter) == "table" then
    if type(linter.cmd) == "string" then
      cmd = linter.cmd
    elseif type(linter.cmd) == "function" then
      local ok2, resolved = pcall(linter.cmd)
      if ok2 and type(resolved) == "string" then cmd = resolved end
    end
  end
  return vim.fn.executable(cmd) == 1 or vim.fn.executable(mason_bin .. cmd) == 1
end

local function try_lint()
  local names = lint.linters_by_ft[vim.bo.filetype]
  if not names then return end
  local runnable = vim.tbl_filter(available, names)
  if #runnable == 0 then return end
  pcall(lint.try_lint, runnable)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("Lint", { clear = true }),
  callback = try_lint,
})

vim.api.nvim_create_user_command("Lint", try_lint, { desc = "Run linters for this buffer" })
