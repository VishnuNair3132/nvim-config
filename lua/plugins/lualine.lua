local icons = require("core.icons")

local function dap_status()
  local ok, dap = pcall(require, "dap")
  if not ok then return "" end
  return dap.status()
end

local function lsp_names()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = {}
  for _, c in ipairs(clients) do table.insert(names, c.name) end
  return " " .. table.concat(names, ",")
end

require("lualine").setup({
  options = {
    theme = "auto",   -- follows the active colorscheme
    globalstatus = true,
    component_separators = { left = icons.ui.separator, right = icons.ui.separator },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "NvimTree", "dapui_scopes", "dapui_breakpoints" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", { "diff", symbols = { added = icons.git.added .. " ", modified = icons.git.modified .. " ", removed = icons.git.removed .. " " } } },
    lualine_c = {
      { "filename", path = 1, symbols = { modified = " " .. icons.ui.modified, readonly = " " .. icons.ui.readonly } },
      { "diagnostics", sources = { "nvim_diagnostic" } },
    },
    lualine_x = {
      { dap_status, cond = function() return dap_status() ~= "" end },
      lsp_names,
      "encoding",
      "fileformat",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = { "nvim-tree", "quickfix", "toggleterm", "trouble" },
})
