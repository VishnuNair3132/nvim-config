-- Buffer-local keymaps + features, applied whenever any server attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    local tb_ok, tb = pcall(require, "telescope.builtin")

    map("n", "gd", tb_ok and tb.lsp_definitions or vim.lsp.buf.definition, "Definition")
    map("n", "gr", tb_ok and tb.lsp_references or vim.lsp.buf.references, "References")
    map("n", "gi", tb_ok and tb.lsp_implementations or vim.lsp.buf.implementation, "Implementation")
    map("n", "gt", tb_ok and tb.lsp_type_definitions or vim.lsp.buf.type_definition, "Type definition")
    map("n", "gD", vim.lsp.buf.declaration, "Declaration")
    map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")
    map({ "n", "i" }, "<C-s>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")
    map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
    map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", "LSP info")
    map("n", "<leader>lR", function() vim.cmd("LspRestart") end, "Restart server")

    -- Inlay hints (Go, TS, clangd all support these)
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
      map("n", "<leader>lh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, "Toggle inlay hints")
    end

    -- Highlight the symbol under the cursor
    if client:supports_method("textDocument/documentHighlight") then
      local group = vim.api.nvim_create_augroup("LspHighlight" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr, group = group, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr, group = group, callback = vim.lsp.buf.clear_references,
      })
    end

    -- 0.11 already maps K, gra, grn, grr etc.; ours above take precedence.
  end,
})
