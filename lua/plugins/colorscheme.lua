-- Emacs-flavoured themes.
--
--   modus_operandi / modus_vivendi  Protesilaos' Modus themes — these ship *with*
--                                   Emacs 28+ as the built-in accessible themes.
--                                   Highest contrast (WCAG AAA), very flat.
--   doom-one                        The Doom Emacs default. What most people
--                                   picture when they say "Emacs but modern".
--   zenburn                         Originated as an Emacs theme in 2003; low
--                                   contrast, warm greys.
--
-- <leader>ut  toggles light/dark, same as Emacs' `modus-themes-toggle`
-- <leader>uT  opens a live-preview picker, same idea as `M-x load-theme`
-- The choice is written to disk, so it survives a restart.

local M = {}

local state_file = vim.fn.stdpath("state") .. "/colorscheme.txt"
local DEFAULT = "modus_vivendi"

require("modus-themes").setup({
  style = "auto",        -- follows vim.o.background
  variants = {           -- "default" | "tinted" | "deuteranopia" | "tritanopia"
    modus_operandi = "default",
    modus_vivendi = "default",
  },
  transparent = false,
  dim_inactive = false,
  hide_inactive_statusline = false,
  line_nr_column_background = false,
  sign_column_background = false,
  styles = {
    comments = { italic = true },
    keywords = { italic = false, bold = true },
    functions = { bold = true },
    variables = {},
  },
  on_highlights = function(hl, c)
    -- Emacs draws the modeline as a solid slab; mimic that under lualine.
    hl.WinSeparator = { fg = c.border }
    hl.CursorLineNr = { fg = c.fg_main, bold = true }
  end,
})

-- NOTE: loading either modus variant sets vim.g.colors_name to "modus", not to
-- the name you asked for -- so the toggle below tracks the requested name
-- itself instead of reading colors_name back.
local current = DEFAULT

local function persist()
  pcall(vim.fn.writefile, { current, vim.o.background }, state_file)
end

function M.apply(name, remember)
  if name == "doom-one" then
    vim.o.background = "dark"
    local ok = pcall(function()
      require("doom-one").setup({
        cursor_coloring = false,
        terminal_colors = true,
        italic_comments = true,
        enable_treesitter = true,
        transparent_background = false,
        pumblend = { enable = true, transparency_amount = 20 },
        plugins_integrations = {
          neorg = false, barbar = false, bufferline = true, gitgutter = false,
          gitsigns = true, telescope = true, neogit = false, nvim_tree = true,
          dashboard = false, startify = false, whichkey = true,
          indent_blankline = true, vim_illuminate = false, lspsaga = false,
        },
      })
    end)
    if not ok then pcall(vim.cmd.colorscheme, "doom-one") end
  else
    if name == "modus_operandi" then vim.o.background = "light" end
    if name == "modus_vivendi" then vim.o.background = "dark" end
    local ok = pcall(vim.cmd.colorscheme, name)
    if not ok then
      vim.notify("colorscheme '" .. name .. "' not found; using " .. DEFAULT, vim.log.levels.WARN)
      pcall(vim.cmd.colorscheme, DEFAULT)
      current = DEFAULT
      return
    end
  end
  current = name
  if remember ~= false then persist() end
end

-- Restore the last choice (name on line 1, background on line 2)
local saved, saved_bg = DEFAULT, nil
if vim.uv.fs_stat(state_file) then
  local ok, lines = pcall(vim.fn.readfile, state_file)
  if ok and lines then
    if lines[1] and lines[1] ~= "" then saved = lines[1] end
    if lines[2] and lines[2] ~= "" then saved_bg = lines[2] end
  end
end
M.apply(saved, false)
if saved_bg and saved ~= "modus_operandi" and saved ~= "modus_vivendi" then
  vim.o.background = saved_bg
end

-- modus-themes-toggle
vim.keymap.set("n", "<leader>ut", function()
  if current == "modus_operandi" then
    M.apply("modus_vivendi")
  elseif current == "modus_vivendi" then
    M.apply("modus_operandi")
  else
    M.apply(vim.o.background == "dark" and "modus_operandi" or "modus_vivendi")
  end
end, { desc = "Toggle light/dark (modus)" })

-- M-x load-theme
vim.keymap.set("n", "<leader>uT", function()
  local ok, telescope = pcall(require, "telescope.builtin")
  if not ok then return vim.cmd("colorscheme") end
  telescope.colorscheme({ enable_preview = true })
end, { desc = "Pick colorscheme (load-theme)" })

vim.api.nvim_create_user_command("LoadTheme", function(a)
  M.apply(a.args)
end, {
  nargs = 1,
  complete = function() return vim.fn.getcompletion("", "color") end,
  desc = "Set and remember a colorscheme",
})

-- Catch themes chosen through the telescope picker too
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("PersistColorscheme", { clear = true }),
  callback = function(ev)
    if ev.match ~= "modus" then current = ev.match end
    persist()
  end,
})

return M
