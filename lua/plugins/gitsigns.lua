local g = require("core.icons").git

require("gitsigns").setup({
  signs = {
    add          = { text = g.add },
    change       = { text = g.change },
    delete       = { text = g.delete },
    topdelete    = { text = g.topdelete },
    changedelete = { text = g.changedelete },
    untracked    = { text = g.untracked },
  },
  current_line_blame = false,
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("n", "]h", gs.next_hunk, "Next hunk")
    map("n", "[h", gs.prev_hunk, "Prev hunk")
    map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
    map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
    map("n", "<leader>gS", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
    map("n", "<leader>gd", gs.diffthis, "Diff this")
  end,
})
