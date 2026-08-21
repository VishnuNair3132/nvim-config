require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c", "cpp", "java", "go", "gomod", "gosum", "gowork",
    "javascript", "typescript", "tsx", "html", "css", "json", "jsonc",
    "lua", "luadoc", "vim", "vimdoc", "query",
    "bash", "python", "markdown", "markdown_inline", "yaml", "toml",
    "dockerfile", "make", "cmake", "regex", "diff", "gitcommit", "sql",
  },
  auto_install = true,
  sync_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true, disable = { "python" } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      node_decremental = "<BS>",
      scope_incremental = false,
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer", ["if"] = "@function.inner",
        ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",["ia"] = "@parameter.inner",
        ["ai"] = "@conditional.outer", ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",     ["il"] = "@loop.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>a"] = "@parameter.inner" },
      swap_previous = { ["<leader>A"] = "@parameter.inner" },
    },
  },
})
