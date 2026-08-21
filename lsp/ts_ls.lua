-- JavaScript / TypeScript.  Install: :MasonInstall typescript-language-server
local inlay = {
  includeInlayParameterNameHints = "literal",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript", "javascriptreact", "javascript.jsx",
    "typescript", "typescriptreact", "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  init_options = { hostInfo = "neovim" },
  settings = {
    typescript = {
      inlayHints = inlay,
      preferences = { importModuleSpecifierPreference = "non-relative" },
      updateImportsOnFileMove = { enabled = "always" },
    },
    javascript = { inlayHints = inlay },
    completions = { completeFunctionCalls = true },
  },
}
