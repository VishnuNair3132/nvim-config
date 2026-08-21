local dap = require("dap")
local dapui = require("dapui")

require("nvim-dap-virtual-text").setup({ commented = true })
dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.35 },
        { id = "breakpoints", size = 0.15 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 44, position = "left",
    },
    { elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } }, size = 12, position = "bottom" },
  },
})

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- Signs
local dicons = require("core.icons").dap
vim.fn.sign_define("DapBreakpoint", { text = dicons.breakpoint, texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = dicons.breakpoint_cond, texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = dicons.breakpoint_rejected, texthl = "DiagnosticError" })
vim.fn.sign_define("DapLogPoint", { text = dicons.logpoint, texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = dicons.stopped, texthl = "DiagnosticWarn", linehl = "Visual" })

local mason_bin = vim.fn.stdpath("data") .. "/mason/packages/"

---------------------------------------------------------------- C / C++ (codelldb)
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = mason_bin .. "codelldb/extension/adapter/codelldb",
    args = { "--port", "${port}" },
  },
}

local c_config = {
  {
    name = "Launch executable",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      local input = vim.fn.input("Args: ")
      return vim.split(input, " ", { trimempty = true })
    end,
  },
  {
    name = "Attach to process",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}
dap.configurations.c = c_config
dap.configurations.cpp = c_config

---------------------------------------------------------------------------- Go
require("dap-go").setup({
  delve = { detached = vim.fn.has("win32") == 0 },
})

------------------------------------------------------------- JavaScript / TypeScript
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { mason_bin .. "js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
  },
}

for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
  dap.configurations[lang] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      runtimeExecutable = "node",
      skipFiles = { "<node_internals>/**" },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to process",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
  }
end

-- Java: configurations are registered by nvim-jdtls (see after/ftplugin/java.lua)

------------------------------------------------------------------------ keymaps
local map = vim.keymap.set
map("n", "<F5>",  function() dap.continue() end,          { desc = "DAP continue" })
map("n", "<F10>", function() dap.step_over() end,         { desc = "DAP step over" })
map("n", "<F11>", function() dap.step_into() end,         { desc = "DAP step into" })
map("n", "<F12>", function() dap.step_out() end,          { desc = "DAP step out" })
map("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dl", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, { desc = "Log point" })
map("n", "<leader>dr", function() dap.repl.toggle() end,  { desc = "DAP REPL" })
map("n", "<leader>du", function() dapui.toggle() end,     { desc = "DAP UI toggle" })
map("n", "<leader>dt", function() dap.terminate() end,    { desc = "DAP terminate" })
map("n", "<leader>dc", function() dap.run_to_cursor() end,{ desc = "Run to cursor" })
map({ "n", "v" }, "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, { desc = "Eval expression" })
