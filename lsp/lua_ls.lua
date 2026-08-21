-- Lua, tuned for editing this Neovim config. Install: :MasonInstall lua-language-server
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        -- Do NOT use vim.api.nvim_get_runtime_file("", true) here. That hands
        -- lua_ls every runtime dir -- including all ~47 plugins -- to index,
        -- which measured at ~60s before the first diagnostic appeared. Scoping
        -- it to core runtime + luv types brings that under ~2s and still gives
        -- full `vim.*` completion. For plugin type defs on demand, add
        -- folke/lazydev.nvim.
        library = {
          vim.env.VIMRUNTIME .. "/lua",
          vim.fn.stdpath("config") .. "/lua",
          "${3rd}/luv/library",
        },
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
      diagnostics = { globals = { "vim" } },
      hint = { enable = true, arrayIndex = "Disable" },
      telemetry = { enable = false },
      format = { enable = false }, -- stylua via conform
    },
  },
}
