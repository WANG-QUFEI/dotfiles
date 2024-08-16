-- ### set up lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("lazy").setup({
	spec = { { import = "plugins" } },
	checker = { enabled = false },
})

vim.opt.cursorline = false
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd([[inoremap <C-f> <Right>]])
vim.cmd([[inoremap <C-b> <Left>]])
vim.cmd([[colorscheme tokyonight-night]])
vim.api.nvim_create_user_command("EditNvimConfig", function()
	vim.cmd([[ lcd ~/.config/nvim | edit init.lua ]])
end, { desc = "Locally enter the nvim config directory and edit init.lua" })
vim.cmd([[nnoremap \ei :<C-u>EditNvimConfig<CR>]])

require("mini.basics").setup()
require("mini.bracketed").setup()
require("mini.comment").setup()
require("mini.cursorword").setup()
require("mini.pairs").setup()
require("autocomp_cfg").setup()
require("fzf_cfg").setup()
require("lsp_cfg").setup()

-- ### language specific settings
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
	group = format_sync_grp,
})

--- ### formatter settings
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		json = { require("formatter.filetypes.json").jq },
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
