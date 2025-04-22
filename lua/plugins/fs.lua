--- @module 'plugins.fs'
--- All file system related plugins

local func = require("util.func")
local keymaps = require("config.keymaps")
return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            -- Nerd fonts for icons
            "nvim-tree/nvim-web-devicons",
        },
        keys = keymaps.nvim_tree.keys,
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.g.nvim_tree_width = 30
        end,
        lazy = false,
        cond = function()
            return func.check_global_var("use_nvim_tree", true, true)
        end,
        config = function()
            require("nvim-tree").setup()
        end,
    },
}
