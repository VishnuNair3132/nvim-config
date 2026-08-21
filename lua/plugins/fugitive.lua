-- vim-fugitive: git operations that work better as buffers than as a TUI.
--
-- This deliberately does NOT duplicate what you already have:
--   gitsigns  -> hunk signs, staging, blame while editing  (<leader>g p/r/S/b/d)
--   lazygit   -> interactive rebase, branches, stashes      (<leader>gg)
--   fugitive  -> merge conflicts, deep blame, old revisions (below)
--
-- Fugitive needs no setup() call; everything here is keymaps and window
-- housekeeping.

local map = vim.keymap.set

------------------------------------------------------------------ status / log
map("n", "<leader>gG", "<cmd>Git<CR>", { desc = "Git status (fugitive)" })
map("n", "<leader>ga", "<cmd>Gwrite<CR>", { desc = "Stage current file" })
map("n", "<leader>gl", "<cmd>Gclog<CR>", { desc = "Git log (repo)" })
map("n", "<leader>gL", "<cmd>0Gclog<CR>", { desc = "Git log (current file)" })

-- Deep blame. Unlike gitsigns' one-line popup this is a scrollbound buffer:
-- <CR> opens the commit, o opens it in a split, - reblames at the parent.
map("n", "<leader>gm", "<cmd>Git blame<CR>", { desc = "Git blame (scrollbound)" })

------------------------------------------------------------------------- diffs
map("n", "<leader>gD", "<cmd>Gdiffsplit<CR>", { desc = "Diff against index" })
map("n", "<leader>gM", "<cmd>Gdiffsplit!<CR>", { desc = "3-way merge (conflicts)" })

-- Conflict resolution. The 2 / 3 mirror fugitive's own //2 and //3 syntax:
--   //2 = target branch  (what you were on / "ours")
--   //3 = merge source   (what you are merging in / "theirs")
map("n", "<leader>g2", "<cmd>diffget //2<CR>", { desc = "Conflict: take ours (//2)" })
map("n", "<leader>g3", "<cmd>diffget //3<CR>", { desc = "Conflict: take theirs (//3)" })

------------------------------------------------------------------- push / browse
map("n", "<leader>gP", "<cmd>Git push<CR>", { desc = "Git push" })
map({ "n", "v" }, "<leader>gx", "<cmd>GBrowse<CR>", { desc = "Open line on GitHub (rhubarb)" })

------------------------------------------------------------------------ helpers
-- Load every unmerged file into the quickfix list, so ]q / [q walks the
-- conflicts instead of you hunting for them.
vim.api.nvim_create_user_command("Conflicts", function()
  local out = vim.fn.systemlist("git diff --name-only --diff-filter=U")
  if vim.v.shell_error ~= 0 then
    return vim.notify("not a git repository", vim.log.levels.WARN)
  end
  if #out == 0 then
    return vim.notify("no merge conflicts", vim.log.levels.INFO)
  end
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local items = {}
  for _, f in ipairs(out) do
    items[#items + 1] = { filename = root .. "/" .. f, lnum = 1, text = "unmerged" }
  end
  vim.fn.setqflist(items, "r")
  vim.cmd("copen")
end, { desc = "Put conflicted files in the quickfix list" })

-- Fugitive's own buffers should close with q like every other scratch window.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FugitiveClose", { clear = true }),
  pattern = { "fugitive", "fugitiveblame", "git" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
  end,
})
