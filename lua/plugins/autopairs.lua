require("nvim-autopairs").setup({ check_ts = true })
local ok, cmp = pcall(require, "cmp")
if ok then
  cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
end
