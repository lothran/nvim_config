vim.lsp.enable({
  'protols',
  'clangd',
  'rust_analyzer',
  'pyright',
  'ts_ls',
  'glslls',
  'julials',
  'ltex',
  'neocmake',
  'zls',
  'texlab',
  'jsonls',
  'lua_ls' });




local jit = require("jit")
require("mason").setup()
if (jit.arch == "x86" or jit.arch == "x64") then
  require("mason-lspconfig").setup({
    ensure_installed = { "clangd" },

  })
end


local capabilities =
    require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.textDocument.semanticTokens.multilineTokenSupport = true;
vim.lsp.config('*', { capabilities = capabilities, root_markers = { '.git' } });

require("lsp-format").setup {}
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    require("lsp-format").on_attach(client, args.buf)
  end,
})





vim.api.nvim_create_autocmd('LspAttach', {

  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>fm', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.lsp.set_log_level("ERROR")
