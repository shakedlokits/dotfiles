return {
	{ "folke/snacks.nvim" },

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
}
