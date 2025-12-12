return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			filters = {
				dotfiles = false,
				custom = { "^.git$", "node_modules", ".cache" },
			},
			git = { ignore = false },
		})
	end,
}
