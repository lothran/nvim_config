require("mason").setup()


lsp_servers = {
    'clangd',
    'rust_analyzer',
    'pyright',
    'tsserver',
    'julials',
    'ltex',
    'neocmake',
    'zls',
    'texlab',
    'lua_ls' };
lsp_opts = {
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




require("mason-lspconfig").setup({
    ensure_installed = lsp_servers,

})
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force",
    capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true







require("lsp-format").setup {}

local lspconfig = require('lspconfig')

for _, lsp in ipairs(lsp_servers) do
    if (lsp_opts[lsp] == nil) then
        lspconfig[lsp].setup {
            capabilities = capabilities,
            on_attach = require("lsp-format").on_attach
        }
    else
        lspconfig[lsp].setup {
            capabilities = capabilities,
            settings = lsp_opts[lsp],
            on_attach = require("lsp-format").on_attach
        }
    end
end

lspconfig["glslls"].setup {
    cmd = { "/home/carad/projects/glsl-language-server/build/glslls", "--stdin" },
    capabilities = capabilities,
    on_attach = require("lsp-format").on_attach
}





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

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        {
            name = "latex_symbols",
            option = {
                strategy = 0, -- mixed
            },
        }
    },
}
