-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
vim.opt.number      = true
vim.opt.cursorline  = true
vim.opt.smartindent = true
vim.opt.expandtab   = true
vim.opt.tabstop     = 2
vim.opt.shiftwidth  = 2
vim.opt.laststatus  = 3
vim.opt.cmdheight   = 0
vim.opt.numberwidth = 4
vim.opt.signcolumn  = 'yes'
vim.opt.clipboard   = 'unnamedplus'


vim.o.sessionoptions  = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.background      = "dark"
vim.opt.termguicolors = true
vim.g.node_host_prog  = io.popen("/usr/bash -c 'nvm which default || node'"):read('*a');
vim.opt.signcolumn    = 'auto:1-2'
vim.opt.scroll        = 50




-------------------------------------------------------------------------------
-- Keymap
-------------------------------------------------------------------------------
vim.g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = ' '


vim.keymap.set({ 'n', 'i', 't', 'v' }, "<C-h>", "<C-w>h")
vim.keymap.set({ 'n', 'i', 't', 'v' }, "<C-j>", "<C-w>j")
vim.keymap.set({ 'n', 'i', 't', 'v' }, "<C-k>", "<C-w>k")
vim.keymap.set({ 'n', 'i', 't', 'v' }, "<C-l>", "<C-w>l")
vim.keymap.set('n', "<space>sh", "<CMD>ClangdSwitchSourceHeader<CR>")
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.keymap.set({ 'n', 'i', 'v' }, '<C-n>', '<C-d>')
vim.keymap.set({ 'n', 'i', 'v' }, '<C-p>', '<C-u>')

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
local function show_symboles()
  local telescope = require('telescope.builtin')
  telescope.lsp_workspace_symbols({
    shorten_path = true,
    symbols = {
      "function", "object", "interface",
      "class",
      "constructor",
      "method",
    }
  });
end



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
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      printf_statements = {
        -- add a custom printf statement for cpp
        cpp = {
          'std::cout << "%s" << std::endl;'
        },
        c = {
          'pr_err("%s \\n");'
        }
      }

    },
    keys = {
      {
        "<leader>rp",
        function() require('refactoring').debug.printf({ below = false }) end,
        mode = "n"
      }

    },
  },
  {
    'aliqyan-21/darkvoid.nvim',
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = true
        }
      }
    },
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
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    },
    opts = {},
    config = function()
      require('incline-conf')
    end,
  },
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      {
        "<leader>ss",
        function()
          require('grug-far').open({
            prefills = {
              search = vim.fn.expand("<cword>")
            }
          })
        end,
        mode = { "n" }
      },
      {
        "<leader>ss",
        function()
          local search = vim.fn.getreg('/')
          -- surround with \b if "word" search (such as when pressing `*`)
          if search and vim.startswith(search, '\\<') and vim.endswith(search, '\\>') then
            search = '\\b' .. search:sub(3, -3) .. '\\b'
          end
          require('grug-far').open({
            prefills = {
              search = search,
            },
          })
        end,
        mode = { "v" }
      },
      {
        "<leader>sf",
        function()
          require('grug-far').open({
            prefills = {
              paths = vim.fn.expand("%"),
              search = vim.fn.expand("<cword>")
            }
          })
        end,
        mode = { "n" }

      },
      {
        "<leader>sf",
        function()
          local search = vim.fn.getreg('/')
          -- surround with \b if "word" search (such as when pressing `*`)
          if search and vim.startswith(search, '\\<') and vim.endswith(search, '\\>') then
            search = '\\b' .. search:sub(3, -3) .. '\\b'
          end
          require('grug-far').open({
            prefills = {
              paths = vim.fn.expand("%"),
              search = search,
            },
          })
        end,
        mode = { "v" }
      },
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
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },

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
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nordic').setup(
        {
          --   after_palette = function(palette)
          --     local U = require("nordic.utils")
          --     palette.bg_visual = U.blend(palette.orange.base, palette.bg, 0.8)
          --   end
        }

      )
    end
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
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',
    build = 'cargo build --release',
    version = 'v0.13.1',
    opts = {
      keymap = { preset = 'default' },


      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },
      signature = { enabled = true },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'buffer' },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" }

  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      'saghen/blink.cmp',
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
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }

    },
    keys = {

      { "<space>ff",  "<CMD>Telescope find_files<CR>",                            mode = { "n", "v" } },
      { "<space>fh",  "<CMD>Telescope find_files hidden=true no_ignore=true<CR>", mode = { "n", "v" } },
      { "<space>b",   "<CMD>Telescope buffers<CR>",                               mode = { "n", "v" } },
      { "<space>gf",  "<CMD>Telescope live_grep<CR>",                             mode = { "n", "v" } },
      { "<space>k",   "<CMD>Telescope keymaps<CR>",                               mode = { "n", "v" } },
      { "<space>gw",  "<CMD>Telescope grep_string<CR>",                           mode = { "n", "v" } },
      { "<space>tt",  "<CMD>Telescope<CR>",                                       mode = { "n", "v" } },
      { "<space>dia", "<CMD>Telescope diagnostics<CR>",                           mode = { "n", "v" } },
      { "<space>ls",  function() show_symboles() end,                             mode = { "n", "v" } },
      { "<space>gs",  "<CMD>Telescope git_status<CR>",                            mode = { "n", "v" } },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          }
        },
        pickers = {
          find_files = {
            hidden = "true",
            file_ignore_patterns = { 'node_modules', '.git', '.venv', '.nvim', '.repo' },
          },
          colorscheme = {
            enable_preview = true
          }
        },
      }

      require('telescope').load_extension('fzf')
    end
  },
  -- {
  --   "sindrets/diffview.nvim",
  --   keys = {
  --     { "<space>gd", "<CMD>DiffviewOpen<CR>" },
  --   },
  --   config = {
  --     keymaps = {
  --       view = {
  --         ["<space>gd"] = "<CMD>DiffviewClose<CR>",
  --       },
  --       file_panel = {
  --         ["<space>gd"] = "<CMD>DiffviewClose<CR>",
  --         ["c"] = "<CMD>DiffviewClose",
  --       },
  --     },
  --   }
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { "<space>fs", "<CMD>Neotree<CR>", mode = { "n", "v" } }
    }
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'lua', 'rust', 'vimdoc', 'cpp', 'python', 'bash', 'bitbake', 'glsl' },
        highlight = { enable = true, },
        sync_install = true,
        auto_install = true
      }
    end
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
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine-conf')
    end

  },

  { 'akinsho/git-conflict.nvim', version = "*", config = true },
  {
    "sho-87/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "ramojus/mellifluous.nvim",
    opts = {}

  },
  {
    "ashen-org/ashen.nvim",
    -- optional but recommended,
    -- pin to the latest stable release:
    opts = {
      -- your settings here
    }
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     hint_prefix = "⇥ "
  --
  --   },
  --   config = function(_, opts) require 'lsp_signature'.setup(opts) end
  -- },
  -- {
  --   "rachartier/tiny-glimmer.nvim",
  --   event = "VeryLazy",
  --   priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings
  --   opts = {
  --     overwrite = {
  --       yank = {
  --         enabled = true,
  --         default_animation = "rainbow",
  --       },
  --       search = {
  --         enabled = true,
  --         default_animation = {
  --           name = "rainbow",
  --           settings = {
  --             to_color = vim.opt.hlsearch and "CurSearch" or "Search",
  --           },
  --         },
  --       },
  --       paste = {
  --         enabled = true,
  --         default_animation = "rainbow",
  --       },
  --       yank = {
  --         enabled = true,
  --         default_animation = "rainbow",
  --       },
  --       undo = {
  --         enabled = true,
  --         default_animation = "rainbow",
  --       },
  --       redo = {
  --         enabled = true,
  --         default_animation = "rainbow",
  --
  --       }
  --     },
  --     support = {
  --       -- Enable support for gbprod/substitute.nvim
  --       -- You can use it like so:
  --       -- require("substitute").setup({
  --       --     on_substitute = require("tiny-glimmer.support.substitute").substitute_cb,
  --       --     highlight_substituted_text = {
  --       --         enabled = false,
  --       --     },
  --       --})
  --       substitute = {
  --         enabled = true,
  --
  --         -- Can also be a table. Refer to overwrite.search for more information
  --         default_animation = "rainbow",
  --       },
  --     },
  --     default_animation = "rainbow",
  --     animations = {
  --       rainbow = {
  --         max_duration = 200,
  --         min_duration = 100,
  --         chars_for_max_duration = 20,
  --       },
  --     }
  --   },
  -- },
  {
    "bassamsdata/namu.nvim",
    config = function()
      require("namu").setup({
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {
            multiselect = {
              enabled = false
            },
            movement = { -- Support multiple keys
              next = { "<C-n>", "<DOWN>", "<TAB>" },
            }

          }, -- here you can configure namu
        },
        -- Optional: Enable other modules if needed
        colorscheme = {
          enable = false,
          options = {
            -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
            persist = true,      -- very efficient mechanism to Remember selected colorscheme
            write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
          },
        },
      })
      -- === Suggested Keymaps: ===
      vim.keymap.set("n", "<leader>sm", ":Namu symbols<cr>", {
        desc = "Jump to LSP symbol",
        silent = true,
      })
      vim.keymap.set("n", "<leader>th", ":Namu colorscheme<cr>", {
        desc = "Colorscheme Picker",
        silent = true,
      })
    end,
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      bigfile = {
        -- your bigfile configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    }
  }
}

require('lazy').setup(plugins)

vim.cmd [[colorscheme  gruvbox]]
