local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, display_name = "LazyGit", close_on_exit = true })
local remote   = Terminal:new({ display_name = "remote" })

vim.keymap.set("n", "<leader>g", function() lazygit:toggle() end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>r", function() remote:toggle() end, { noremap = true, silent = true })
