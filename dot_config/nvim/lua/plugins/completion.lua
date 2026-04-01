return {
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				opts = {},
			},
			"folke/lazydev.nvim",
			"Kaiser-Yang/blink-cmp-avante",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				["<M-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<M-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },

				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<M-k>"] = { "select_prev", "fallback" },
				["<M-j>"] = { "select_next", "fallback" },

				["<M-b>"] = { "scroll_documentation_up", "fallback" },
				["<M-f>"] = { "scroll_documentation_down", "fallback" },

				["<M-n>"] = { "show_signature", "hide_signature", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				trigger = { prefetch_on_insert = false },
							ghost_text = { enabled = true },
			},
			sources = {
				default = { "lsp", "path", "buffer", "snippets", "lazydev", "avante" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
					avante = {
						module = "blink-cmp-avante",
						name = "Avante",
						opts = {
							-- options for blink-cmp-avante
						},
					},
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},
}
