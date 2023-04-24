local fzf_cfg = {}
function fzf_cfg.setup()
	require('telescope').setup({
		defaults = {
			border = false,
			mappings = {
				i = {
					["<C-h>"] = "which_key"
				}
			},
		}
	})
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
	vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
	vim.keymap.set('n', '<leader>fc', builtin.command_history, {})
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
	vim.keymap.set('n', '<leader>lr', builtin.lsp_references, {})
	vim.keymap.set('n', '<leader>ls', builtin.lsp_workspace_symbols, {})
	vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, {})
	vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, {})
	vim.keymap.set('n', '<leader>lt', builtin.lsp_type_definitions, {})
	vim.keymap.set('n', '<leader><leader>gb', builtin.git_branches, {})
	vim.keymap.set('n', '<leader><leader>gc', builtin.git_commits, {})
	vim.keymap.set('n', '<leader><leader>gs', builtin.git_status, {})

	require('telescope').load_extension('fzf')
end
return fzf_cfg
