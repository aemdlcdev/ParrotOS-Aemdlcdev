local map = vim.keymap.set
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Guardar" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Cerrar" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Limpiar búsqueda" })
map("n", "<C-h>", "<C-w>h", { desc = "Ventana izquierda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ventana inferior" })
map("n", "<C-k>", "<C-w>k", { desc = "Ventana superior" })
map("n", "<C-l>", "<C-w>l", { desc = "Ventana derecha" })

