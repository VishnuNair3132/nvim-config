local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()


cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then luasnip.jump(1)
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip", priority = 750 },
    { name = "path", priority = 500 },
  }, {
    { name = "buffer", keyword_length = 3 },
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, item)
      item.kind = string.format("%-9s", item.kind)
      item.menu = ({
        nvim_lsp = "[LSP]", luasnip = "[Snip]", buffer = "[Buf]", path = "[Path]",
      })[entry.source.name]
      item.abbr = vim.fn.strcharpart(item.abbr, 0, 50)
      return item
    end,
  },
  experimental = { ghost_text = true },
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})
