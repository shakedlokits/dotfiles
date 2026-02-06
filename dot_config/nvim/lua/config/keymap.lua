-- General

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Navigation (Telescope)

vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", "<cmd>Telescope builtin<cr>", { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", "<cmd>Telescope resume<cr>", { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", "<cmd>Telescope oldfiles<cr>", { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope buffers<cr>", { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope file_browser<cr>", { desc = "[S]earch File [B]rowser" })

vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>s/", function()
	require("telescope.builtin").live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

vim.keymap.set("n", "<leader>sn", function()
	require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Navigation (Oil)

vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "[O]il" })

-- Navigation (Harpoon)

vim.keymap.set("n", "<leader>ha", function()
	require("harpoon"):list():add()
end, { desc = "Harpoon [A]dd File" })

vim.keymap.set("n", "<leader>hh", function()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Menu" })

for i = 1, 9 do
	vim.keymap.set("n", "<leader>h" .. i, function()
		require("harpoon"):list():select(i)
	end, { desc = "Harpoon to File " .. i })
end

-- Git

vim.keymap.set("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "[L]azyGit" })

-- Buffer (Snacks Scratch)

vim.keymap.set("n", "<leader>b.", function()
	require("snacks").scratch()
end, { desc = "Toggle Scratch Buffer" })

vim.keymap.set("n", "<leader>bs", function()
	require("snacks").scratch.select()
end, { desc = "[S]elect Scratch Buffer" })

-- Formatting

vim.keymap.set("", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

-- HTTP (Kulala)

vim.keymap.set("n", "<leader>Rs", function()
	require("kulala").run()
end, { desc = "Send request" })

vim.keymap.set("n", "<leader>Ra", function()
	require("kulala").run_all()
end, { desc = "Send all requests" })

vim.keymap.set("n", "<leader>Rb", function()
	require("kulala").scratchpad()
end, { desc = "Open scratchpad" })

-- AI (Opencode)

vim.keymap.set({ "n", "x" }, "<C-a>", function()
	require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode" })

vim.keymap.set({ "n", "x" }, "<C-x>", function()
	require("opencode").select()
end, { desc = "Execute opencode action…" })

vim.keymap.set({ "n", "x" }, "ga", function()
	require("opencode").prompt("@this")
end, { desc = "Add to opencode" })

vim.keymap.set({ "n", "t" }, "<C-t>", function()
	require("opencode").toggle()
end, { desc = "Toggle opencode" })

vim.keymap.set("n", "<S-C-u>", function()
	require("opencode").command("session.half.page.up")
end, { desc = "Opencode half page up" })

vim.keymap.set("n", "<S-C-d>", function()
	require("opencode").command("session.half.page.down")
end, { desc = "Opencode half page down" })

vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })

-- LSP

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),
	callback = function(event)
		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, { buffer = event.buf, desc = "LSP: Hover Documentation" })
		vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { buffer = event.buf, desc = "LSP: Re[n]ame" })
		vim.keymap.set(
			{ "n", "x" },
			"<leader>la",
			vim.lsp.buf.code_action,
			{ buffer = event.buf, desc = "LSP: Code [A]ction" }
		)
		vim.keymap.set(
			"n",
			"<leader>lr",
			"<cmd>Telescope lsp_references<cr>",
			{ buffer = event.buf, desc = "LSP: [R]eferences" }
		)
		vim.keymap.set(
			"n",
			"<leader>li",
			"<cmd>Telescope lsp_implementations<cr>",
			{ buffer = event.buf, desc = "LSP: [I]mplementation" }
		)
		vim.keymap.set(
			"n",
			"<leader>ld",
			"<cmd>Telescope lsp_definitions<cr>",
			{ buffer = event.buf, desc = "LSP: [D]efinition" }
		)
		vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "LSP: [D]eclaration" })
		vim.keymap.set(
			"n",
			"<leader>ls",
			"<cmd>Telescope lsp_document_symbols<cr>",
			{ buffer = event.buf, desc = "LSP: Document [S]ymbols" }
		)
		vim.keymap.set(
			"n",
			"<leader>lw",
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			{ buffer = event.buf, desc = "LSP: [W]orkspace Symbols" }
		)
		vim.keymap.set(
			"n",
			"<leader>lt",
			"<cmd>Telescope lsp_type_definitions<cr>",
			{ buffer = event.buf, desc = "LSP: [T]ype Definition" }
		)

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			vim.keymap.set("n", "<leader>lh", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, { buffer = event.buf, desc = "LSP: Toggle Inlay [H]ints" })
		end
	end,
})
