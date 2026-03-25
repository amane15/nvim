local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Toggle Nvim Tree
vim.keymap.set("", "<A-e>", ":NvimTreeToggle<CR>", opts)

-- Move text up and down
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", opts)
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", opts)
vim.keymap.set("v", "p", "_dP", opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

vim.api.nvim_create_autocmd("InsertCharPre", {
	callback = function()
		vim.api.nvim_buf_set_keymap(
			0,
			"i",
			"<C-k>",
			"<cmd>lua vim.lsp.buf.signature_help()<CR>",
			{ noremap = true, silent = true }
		)
	end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.go",
-- 	callback = function()
-- 		vim.lsp.buf.code_action({
-- 			context = { only = { "source.organizeImports" } },
-- 			apply = true,
-- 		})
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.go",
-- 	callback = function()
-- 		local params = vim.lsp.util.make_range_params()
-- 		params.context = { only = { "source.organizeImports" } }
--
-- 		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 200)
--
-- 		if not result then
-- 			return
-- 		end
--
-- 		for _, res in pairs(result) do
-- 			for _, action in pairs(res.result or {}) do
-- 				if action.edit then
-- 					vim.lsp.util.apply_workspace_edit(action.edit, "UTF-8")
-- 				elseif action.command then
-- 					vim.lsp.buf.execute_command(action.command)
-- 				end
-- 			end
-- 		end
-- 	end,
-- })
--
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.go",
	callback = function()
		-- avoid infinite loop
		if vim.b._go_organizing_imports then
			return
		end

		vim.b._go_organizing_imports = true

		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports" } },
			apply = true,
		})

		-- write silently after imports are fixed
		vim.cmd("silent! write")

		vim.b._go_organizing_imports = false
	end,
})

vim.keymap.set(
	"i",
	"<C-e>",
	[[if err != nil {
}]],
	{ noremap = true }
)
