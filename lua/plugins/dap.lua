return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"igorlfs/nvim-dap-view",
			"leoluz/nvim-dap-go",
			"nvim-telescope/telescope-dap.nvim",
			"Weissle/persistent-breakpoints.nvim",
            "thehamsta/nvim-dap-virtual-text",
		},

		config = function()
			require("persistent-breakpoints").setup({
				load_breakpoints_event = { "BufReadPost" },
			})

			local dap = require("dap")
			local dv = require("dap-view")

			dv.setup()

			require("nvim-dap-virtual-text").setup({
				enabled = true,
				commented = true,
				virt_text_pos = "eol",
				only_first_definition = true,
				all_references = false,
			})

			require("dap-go").setup()
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch executable",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			dap.configurations.c = dap.configurations.cpp

			dap.listeners.before.attach["dap-view"] = function()
				dv.open()
			end

			dap.listeners.before.launch["dap-view"] = function()
				dv.open()
			end

			dap.listeners.before.event_terminated["dap-view"] = function()
				dv.close()
			end

			dap.listeners.before.event_exited["dap-view"] = function()
				dv.close()
			end
		end,
	},
}
