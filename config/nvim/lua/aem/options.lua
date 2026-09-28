local options = { number = true, relativenumber = true, mouse = "a", ignorecase = true, smartcase = true, splitbelow = true, splitright = true, termguicolors = true, signcolumn = "yes", updatetime = 250, timeoutlen = 400, expandtab = true, shiftwidth = 2, tabstop = 2, undofile = true }
for name, value in pairs(options) do vim.opt[name] = value end

