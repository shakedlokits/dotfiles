return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"folke/trouble.nvim",
		opts = {
			win = { position = "right", size = 0.4 },
		},
		cmd = "Trouble",
	},
}
