local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  group = augroup("HighlightYank", { clear = true }),
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- Restore cursor position
autocmd("BufReadPost", {
  group = augroup("LastLoc", { clear = true }),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Trim trailing whitespace on save (skip markdown)
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  callback = function()
    if vim.bo.filetype == "markdown" then return end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Language-specific indents
autocmd("FileType", {
  group = augroup("Indents", { clear = true }),
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc", "yaml", "html", "css", "lua" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})

autocmd("FileType", {
  group = augroup("GoIndent", { clear = true }),
  pattern = "go",
  callback = function() vim.bo.expandtab = false end,
})

-- Close scratch-ish windows with q
autocmd("FileType", {
  group = augroup("CloseWithQ", { clear = true }),
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "dap-float" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
  end,
})
