-- Go.  Install: :MasonInstall gopls   (or  go install golang.org/x/tools/gopls@latest)
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
      semanticTokens = true,
      analyses = {
        unusedparams = true,
        unusedwrite = true,
        nilness = true,
        shadow = true,
        useany = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      codelenses = { generate = true, gc_details = true, test = true, tidy = true },
    },
  },
}
