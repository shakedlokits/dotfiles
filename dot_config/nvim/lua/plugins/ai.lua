return {
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				provider = {
					enabled = "snacks",
					snacks = {},
				},
			}
			vim.o.autoread = true
		end,
	},
	{
		"milanglacier/minuet-ai.nvim",
		config = function()
			require("minuet").setup({ provider = "claude" })
		end,
	},
}
