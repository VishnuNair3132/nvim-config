-- Auto-closes and renames HTML/JSX tags. Configured separately from
-- treesitter.lua so it does not depend on plugin load order.
require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
})
