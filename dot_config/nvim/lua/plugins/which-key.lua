return {
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				icons = {},
			},
			spec = {
				{ "<leader>b", group = "[B]uffer" },
				{ "<leader>g", group = "[G]it" },
				{ "<leader>h", group = "[H]arpoon" },
				{ "<leader>l", group = "[L]SP" },
				{ "<leader>R", group = "[R]equest (HTTP)" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>d", group = "[D]iagnostics" },
			},
		},
	},
}
