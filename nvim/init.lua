-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
vim.opt.number        = true
vim.opt.cursorline    = true
vim.opt.smartindent   = true
vim.opt.expandtab     = true
vim.opt.tabstop       = 2
vim.opt.shiftwidth    = 2
vim.opt.laststatus    = 3
vim.opt.cmdheight     = 0
vim.opt.numberwidth   = 4
vim.opt.signcolumn    = 'yes'
vim.opt.clipboard     = 'unnamedplus'
vim.o.sessionoptions  = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.background      = "dark"
vim.opt.termguicolors = true
vim.g.node_host_prog  = io.popen("/usr/bash -c 'nvm which default || node'"):read('*a');
vim.opt.signcolumn = 'auto:1-2'




-------------------------------------------------------------------------------
-- Keymap
-------------------------------------------------------------------------------
vim.g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct


vim.keymap.set({ 'n', 'i', 't', 'v' }, "<C-h>", "<C-w>h")
vim.keymap.set({ 'n', 'i', 't', 'v' }, "<C-j>", "<C-w>j")
vim.keymap.set({ 'n', 'i', 't', 'v' }, "<C-k>", "<C-w>k")
vim.keymap.set({ 'n', 'i', 't', 'v' }, "<C-l>", "<C-w>l")
vim.keymap.set('n', "<space>sh", "<CMD>ClangdSwitchSourceHeader<CR>")
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]])
vim.keymap.set({ 'n', 'i', 't', 'v' }, '<c-z>', function() end);
vim.filetype.add({
  extension = {
    glsl = 'glsl',
    frag = 'glsl',
    vert = 'glsl',
    comp = 'glsl',
  }
})



-------------------------------------------------------------------------------
-- Autocmds
-------------------------------------------------------------------------------

--auto save
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_command('silent update')
    end
  end,
})

-------------------------------------------------------------------------------
-- Bootstrap Package Manager
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    'aliqyan-21/darkvoid.nvim',
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            highlight = {
              matches = false,
              backdrop = true,
            },



          })
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {

    'eandrju/cellular-automaton.nvim',
    keys = {
      { "<leader>fck", "<cmd>CellularAutomaton make_it_rain<CR>" }
    }


  },
  {
    "b0o/incline.nvim",
    dependencies = {

    },
    opts = {},
    config = function()
      require('incline-conf')
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>ss", function() require("spectre").toggle() end, desc = "Replace in files (Spectre)" },
    },
  },

  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      { "<space>zen", "<CMD>ZenMode<CR>", mode = { "n", "v" } },

    }
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns_conf")
    end,
  },

  {
    'norcalli/nvim-colorizer.lua',
    opts = {},
    config = function()
      require 'colorizer'.setup()
    end

  },

  {
    'aktersnurra/no-clown-fiesta.nvim',
    config = function()
      require('no-clown-fiesta').setup()
      --vim.cmd [[colorscheme no-clown-fiesta]]
      --vim.cmd([[highlight ColorColumn ctermbg=0 guibg=#576f82]])
    end,
    priority = 100
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
    end,
  },

  { "NTBBloodbath/sweetie.nvim" },
  {
    "nyoom-engineering/oxocarbon.nvim",
    config = function()
    end,
  },
  {
    "sainnhe/gruvbox-material"
  },


  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<space>sr",
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
      },
    },
  },
  {
    "neanias/everforest-nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        -- Your config here
      })
    end,
  },

  {
    'ethanholz/nvim-lastplace', config = true
  },
  {
    "akinsho/toggleterm.nvim",
    config = {
      open_mapping = [[<c-\>]],
      'akinsho/toggleterm.nvim',
      direction = 'float'
    }
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "zbirenbaum/copilot.lua",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-path',
      "kdheepak/cmp-latex-symbols",
      'rafamadriz/friendly-snippets',
      "b0o/schemastore.nvim",
      { 'lukas-reineke/lsp-format.nvim', config = true },
    },
    config = function()
      require("lsp-conf")
    end
  },
  {
    'fedepujol/move.nvim',
    opts = {},
    keys = {
      { '<A-Down>', ':MoveLine(1)<CR>',              mode = { 'n' } },
      { '<A-Up>',   ':MoveLine(-1)<CR>',             mode = { 'n' } },
      { '<A-Down>', ':MoveBlock(1)<CR>',             mode = { 'v' } },
      { '<A-Up>',   ':MoveBlock(-1)<CR>',            mode = { 'v' } },
      { '<A-Down>', '<C-\\><C-N>:MoveLine(1)<CR>i',  mode = { 'i' } },
      { '<A-Up>',   '<C-\\><C-N>:MoveLine(-1)<CR>i', mode = { 'i' } },
    }
  },
  { 'projekt0n/github-nvim-theme' },
  {
    dependencies = 'rktjmp/lush.nvim',
    "mcchrish/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    keys = {
    }
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",

    },
    keys = {

      { "<space>ff",  "<CMD>Telescope find_files<CR>",                            mode = { "n", "v" } },
      { "<space>fh",  "<CMD>Telescope find_files hidden=true no_ignore=true<CR>", mode = { "n", "v" } },
      { "<space>b",   "<CMD>Telescope buffers<CR>",                               mode = { "n", "v" } },
      { "<space>gf",  "<CMD>Telescope live_grep<CR>",                             mode = { "n", "v" } },
      { "<space>c",   "<CMD>Telescope commands<CR>",                              mode = { "n", "v" } },
      { "<space>k",   "<CMD>Telescope keymaps<CR>",                               mode = { "n", "v" } },
      { "<space>gw",  "<CMD>Telescope grep_string<CR>",                           mode = { "n", "v" } },
      { "<space>tt",  "<CMD>Telescope<CR>",                                       mode = { "n", "v" } },
      { "<space>dia", "<CMD>Telescope diagnostics<CR>",                           mode = { "n", "v" } },
      { "<space>sm",  "<CMD>Telescope lsp_document_symbols<CR>",                  mode = { "n", "v" } },
      { "<space>gs",  "<CMD>Telescope git_status<CR>",                            mode = { "n", "v" } },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            hidden = true,

          },
          colorscheme = {
            enable_preview = true
          }
        },
      }
    end
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<space>gd", "<CMD>DiffviewOpen<CR>" },
    },
    config = {
      keymaps = {
        view = {
          ["<space>gd"] = "<CMD>DiffviewClose<CR>",
        },
        file_panel = {
          ["<space>gd"] = "<CMD>DiffviewClose<CR>",
          ["c"] = "<CMD>DiffviewClose",
        },
      },
    }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'lua', 'rust', 'vimdoc', 'cpp', 'python', 'latex', 'glsl' },
        highlight = { enable = true, },
        sync_install = true,
        auto_install = true

      }
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>fs", "<cmd>Neotree toggle<cr>",          desc = "NeoTree" },
      { "<leader>gg", '<cmd>Neotree float git_status<cr>' }
    },
    opts = {
    }
  },
  {
    'simrat39/symbols-outline.nvim',
    opts = {
      symbols = {
        File = { icon = '󰈔', hl = '@text.uri' },
        Module = { icon = '󰆧', hl = '@namespace' },
        Namespace = { icon = '󰅪', hl = '@namespace' },
        Package = { icon = '󰏗', hl = '@namespace' },
        Class = { icon = '𝓒', hl = '@type' },
        Method = { icon = 'ƒ', hl = '@method' },
        Property = { icon = '', hl = '@method' },
        Field = { icon = '󰆨', hl = '@field' },
        Constructor = { icon = '', hl = '@constructor' },
        Enum = { icon = 'ℰ', hl = '@type' },
        Interface = { icon = '󰜰', hl = '@type' },
        Function = { icon = '', hl = '@function' },
        Variable = { icon = '', hl = '@constant' },
        Constant = { icon = '', hl = '@constant' },
        String = { icon = '𝓐', hl = '@string' },
        Number = { icon = '#', hl = '@number' },
        Boolean = { icon = '⊨', hl = '@boolean' },
        Array = { icon = '󰅪', hl = '@constant' },
        Object = { icon = '⦿', hl = '@type' },
        Key = { icon = '🔐', hl = '@type' },
        Null = { icon = 'NULL', hl = '@type' },
        EnumMember = { icon = '', hl = '@field' },
        Struct = { icon = '𝓢', hl = '@type' },
        Event = { icon = '🗲', hl = '@type' },
        Operator = { icon = '+', hl = '@operator' },
        TypeParameter = { icon = '𝙏', hl = '@parameter' },
        Component = { icon = '󰅴', hl = '@function' },
        Fragment = { icon = '󰅴', hl = '@constant' },
      },
    },
    keys = {
      --{ "<leader>smd", "<cmd>SymbolsOutline<cr>" }
    }

  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine-conf')
      require("darkvoid").setup({
        transparent = true, -- set true for transparent
        glow = true
      })
    end

  },

  { 'akinsho/git-conflict.nvim', version = "*", config = true },
  {
    "sho-87/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  }
}

require('lazy').setup(plugins)

vim.cmd [[colorscheme kanagawa-paper]]
