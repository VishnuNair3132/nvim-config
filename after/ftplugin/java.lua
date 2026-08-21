-- Java gets its own launcher because jdtls needs one workspace per project.
-- Install:  :MasonInstall jdtls java-debug-adapter java-test
-- Fedora:   sudo dnf install java-21-openjdk-devel

local ok, jdtls = pcall(require, "jdtls")
if not ok then return end

local mason = vim.fn.stdpath("data") .. "/mason/packages/"
local jdtls_path = mason .. "jdtls"

-- Bail out cleanly if Mason hasn't installed jdtls yet, otherwise we'd spawn
-- `java -jar ""` and produce a baffling error on every .java buffer.
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
if launcher == "" then
  vim.notify("jdtls not installed -- run :InstallTools (or :MasonInstall jdtls)", vim.log.levels.WARN)
  return
end
if vim.fn.executable("java") == 0 then
  vim.notify("`java` not on PATH -- install a JDK 21+ (sudo dnf install java-21-openjdk-devel)", vim.log.levels.WARN)
  return
end

local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }
local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1])
if not root_dir then return end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

-- Debug + test bundles (java-debug-adapter / java-test)
local bundles = {}
vim.list_extend(bundles, vim.split(
  vim.fn.glob(mason .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true), "\n"))
vim.list_extend(bundles, vim.split(
  vim.fn.glob(mason .. "java-test/extension/server/*.jar", true), "\n"))
bundles = vim.tbl_filter(function(v) return v ~= "" end, bundles)

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", jdtls_path .. "/config_linux",
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  init_options = { bundles = bundles },
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      configuration = { updateBuildConfiguration = "interactive" },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      format = { enabled = false }, -- google-java-format via conform
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*", "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*", "org.mockito.Mockito.*",
          "java.util.Objects.requireNonNull",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
    },
  },
  capabilities = (function()
    local caps = vim.lsp.protocol.make_client_capabilities()
    local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_ok then caps = vim.tbl_deep_extend("force", caps, cmp_lsp.default_capabilities()) end
    return caps
  end)(),
  on_attach = function(_, bufnr)
    if #bundles > 0 then
      pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
      pcall(require("jdtls.dap").setup_dap_main_class_configs)
    end
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = "Java: " .. desc })
    end
    map("<leader>jo", jdtls.organize_imports, "Organize imports")
    map("<leader>jv", jdtls.extract_variable, "Extract variable")
    map("<leader>jc", jdtls.extract_constant, "Extract constant")
    map("<leader>jm", jdtls.extract_method, "Extract method")
    map("<leader>jt", jdtls.test_nearest_method, "Test nearest method")
    map("<leader>jT", jdtls.test_class, "Test class")
    vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end,
      { buffer = bufnr, desc = "Java: Extract method" })
  end,
}

jdtls.start_or_attach(config)
