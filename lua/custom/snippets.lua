-- Hand-written LuaSnip snippets. Require this from lua/custom/init.lua to enable.
local ls = require("luasnip")
local s, t, i, fmt = ls.snippet, ls.text_node, ls.insert_node, require("luasnip.extras.fmt").fmt

ls.add_snippets("c", {
  s("main", fmt([[
int main(int argc, char **argv) {{
    {}
    return 0;
}}
  ]], { i(1, "") })),
})

ls.add_snippets("go", {
  s("iferr", fmt([[
if err != nil {{
    return {}
}}
  ]], { i(1, "err") })),
})
