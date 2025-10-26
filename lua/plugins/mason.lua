return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
        require("mason").setup(opts)

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local telescope_builtin = require("telescope.builtin")

        -- Function that runs when LSP attaches to a buffer
        local on_attach = function(_, bufnr)
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- 🧭 Telescope-powered LSP navigation
            map("n", "gd", telescope_builtin.lsp_definitions, "Go to definition")
            map("n", "gr", telescope_builtin.lsp_references, "Find references")
            map("n", "gi", telescope_builtin.lsp_implementations, "Go to implementation")
            map("n", "gt", telescope_builtin.lsp_type_definitions, "Go to type definition")
            map("n", "K", vim.lsp.buf.hover, "Hover documentation")
        end

        -- end
        for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
            vim.lsp.config(server, {
                on_attach = on_attach,
                capabilities = capabilities,
            })
            vim.lsp.enable(server)
        end
    end
}
