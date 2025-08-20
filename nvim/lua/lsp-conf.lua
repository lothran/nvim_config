local lsp_servers = {
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
  'lua_ls' };
local lsp_opts = {
  lua_ls = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}


local jit = require("jit")

require("mason").setup()
if (jit.arch == "x86" or jit.arch == "x64") then
  require("mason-lspconfig").setup({
    ensure_installed = {"clangd"},

  })
end


-- Add additional capabilities supported by nvim-cmp




local capabilities =
    require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
capabilities.textDocument.completion.completionItem.snippetSupport = false

local function on_attach(client, bufnr)
  require("lsp-format").on_attach(client, bufnr)
end




require("lsp-format").setup {}

local lspconfig = require('lspconfig')

for _, lsp in ipairs(lsp_servers) do
  if (lsp_opts[lsp] == nil) then
    if (lsp == 'clangd') then
      lspconfig[lsp].setup {
        capabilities = capabilities,
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        on_attach = on_attach }
    else
      lspconfig[lsp].setup {
        capabilities = capabilities,
        on_attach = on_attach }
    end
  else
    lspconfig[lsp].setup {
      capabilities = capabilities,
      settings = lsp_opts[lsp],
      on_attach = on_attach
    }
  end
end





-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
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

