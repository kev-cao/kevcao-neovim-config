--- @module 'plugins.ai'
--- All AI related plugins

local func = require("util.func")
local keymaps = require("config.keymaps")

return {
    {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        cond = function()
            return func.check_global_var("use_copilot", true, true)
        end,
        keys = keymaps.copilot.keys,
        opts = {
            copilot_node_command = "/Users/kevin/.nodenv/versions/23.9.0/bin/node",
            panel = {
                enabled = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
            },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            -- curl must be installed
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            strategies = {
                chat = {
                    adapter = "copilot",
                    slash_commands = {
                        ["file"] = {
                            opts = {
                                provider = "fzf_lua",
                            },
                        },
                    },
                },
                inline = {
                    adapter = "copilot",
                },
            },
        },
        keys = keymaps.code_companion.keys,
        config = function(_, opts)
            require("codecompanion").setup(opts)
        end,
        cond = function()
            return func.check_global_var("use_codecompanion", true, true)
        end,
    },
}
