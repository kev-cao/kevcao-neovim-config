--- @module 'plugins.ui'
--- All the UI related plugins are defined here.

local func = require("util.func")
local keymaps = require("config.keymaps")

return {
  {
    "sindrets/winshift.nvim",
    keys = keymaps.winshift.keys,
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      "echasnovski/mini.icons",
      "junegunn/fzf",
      "gennaro-tedesco/nvim-possession",
    },
    cond = function()
      return func.check_global_var("use_alpha", true, true)
    end,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
        " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
        " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
        " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
        " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      }
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.val = {
        dashboard.button("e", "   New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("<leader>sf", "󰱼   Search files", ":FzfLua files<CR>"),
        dashboard.button("<leader>sh", "󱋡   Recently opened files", ":FzfLua oldfiles<CR>"),
        dashboard.button("<leader>sm", "   View global marks", ":FzfLua marks<CR>"),
        dashboard.button("<leader>Sl", "󱫭   Open session", ':lua require("nvim-possession").list()<CR>'),
        dashboard.button("q", "󰅚   Quit", ":qa<CR>"),
      }
      dashboard.section.footer.val = require("alpha.fortune")()
      local content_height = #dashboard.section.header.val + (#dashboard.section.buttons.val * 2 - 1) + 3
      dashboard.opts.layout[1].val = vim.fn.floor((vim.fn.winheight(0) - content_height - 10) / 2)
      dashboard.config.opts.noautocmd = true
      alpha.setup(dashboard.config)
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    cond = function()
      return func.check_global_var("use_colorizer", true, true)
    end,
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false, -- load this during startup since it is our main plugin
    priority = 1000, -- make sure this is loaded before all other plugins
    opts = {
      code_style = {
        comments = "none",
      },
      highlights = {
        AlphaHeader = { fg = "#54ACE3" },
        AlphaFooter = { fg = "#FF9E64" },
      },
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      vim.cmd([[colorscheme onedark]])
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "onedark",
        always_show_tabline = false,
      },
      tabline = {
        lualine_a = { "tabs" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {
          {
            function()
              local reg = vim.fn.reg_recording()
              -- If a macro is being recorded, show "Recording @<register>"
              if reg ~= "" then
                return "Recording @" .. reg
              end
              -- Get the full mode name using nvim_get_mode()
              local mode = vim.api.nvim_get_mode().mode
              local mode_map = {
                n = 'NORMAL',
                i = 'INSERT',
                v = 'VISUAL',
                V = 'V-LINE',
                ['^V'] = 'V-BLOCK',
                c = 'COMMAND',
                R = 'REPLACE',
                s = 'SELECT',
                S = 'S-LINE',
                ['^S'] = 'S-BLOCK',
                t = 'TERMINAL',
              }

              -- Return the full mode name
              return mode_map[mode] or mode:upper()
            end,
            color = { fg = "#ff9e64" }
          },
          "filetype",
        },
        lualine_y = {
          {
            function()
              local spinner = { "", "", "", "" }
              return "Debugging... " .. spinner[os.date("%S") % #spinner + 1]
            end,
            cond = function()
              if not package.loaded.dap then
                return false
              end
              local session = require("dap").session()
              return session ~= nil
            end,
          },
          "progress",
        },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
    cond = function()
      return func.check_global_var("use_lualine", true, true)
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = keymaps.whichkey.keys,
    opts = {
      delay = 500,
      sort = { "local", "group", "alphanum", "order", "mod" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add(keymaps.groups)
    end,
    cond = function()
      return func.check_global_var("use_which_key", true, true)
    end,
  },
  {
    "karb94/neoscroll.nvim",
    lazy = false,
    keys = keymaps.neoscroll.keys,
    opts = {
      mappings = { "<C-u>", "<C-d>", "zt", "zz", "zb" },
      duration_multiplier = 0.5,
    },
    config = function(_, opts)
      require("neoscroll").setup(opts)
    end,
    cond = function()
      return func.check_global_var("use_smooth_scroll", true, true)
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
    end,
    cond = function()
      return func.check_global_var("use_noice", true, true)
    end,
  },
}
