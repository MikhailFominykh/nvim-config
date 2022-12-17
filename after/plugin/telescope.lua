require('telescope').setup {
}
require('telescope').load_extension('fzf')
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-/>", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_ivy())
end)
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.git_files)
vim.keymap.set("n", "<leader>b", builtin.buffers)
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep pattern: ") })
end)
