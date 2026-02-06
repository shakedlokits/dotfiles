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
			require("minuet").setup({
				provider = "openai_compatible",
				request_timeout = 4,
				throttle = 1500,
				debounce = 600,
				n_completions = 3,
				notify = "warn",
				provider_options = {
					openai_compatible = {
						end_point = "http://localhost:4000/v1/chat/completions",
						api_key = "TERM",
						model = "claude-sonnet",
						name = "Bedrock",
						stream = true,
						optional = {
							max_tokens = 256,
						},
					},
				},
			})
		end,
	},
}
