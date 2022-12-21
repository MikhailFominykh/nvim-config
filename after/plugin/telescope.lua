require('telescope').setup {
}
require('telescope').load_extension('fzf')
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-/>", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_ivy())
end, { desc = "Telescope current buffer fuzzy find" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep pattern: ") })
end, { desc = "Telescope grep string" })
