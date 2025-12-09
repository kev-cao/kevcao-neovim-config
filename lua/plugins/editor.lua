--- @module 'plugins.editor'
--- All plugins that affect the editor.

local func = require("util.func")
local keymaps = require("config.keymaps")
local config_opts = require("config.opts")

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    cond = function()
      return func.check_global_var("use_folding", true, true)
    end,
    -- Uses default Neovim keys for folding.
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than
            -- 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth -
              curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, {suffix, "MoreMsg"})
        return newVirtText
      end
    },
    config = function(_, opts)
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require('ufo').setup(opts)
    end
  },
  {
    "mhartington/formatter.nvim",
    cond = function()
      return func.check_global_var("use_formatter", true, true)
    end,
    opts = function()
      return {
        tempfile_dir = "/tmp",
        filetype = {
          typescript = {
            require("formatter.filetypes.typescript").prettier,
          },
          javascript = {
            require("formatter.filetypes.javascript").prettier,
          },
          typescriptreact = {
            require("formatter.filetypes.typescriptreact").prettier,
          },
          javascriptreact = {
            require("formatter.filetypes.javascriptreact").prettier,
          },
          go = {
            function()
              if vim.fn.executable("crlfmt") == 1 then
                return {
                  exe = "crlfmt",
                  args = { "-w", "-tab=2", "-wrap=100", "-ignore '.(pb(.gw)?)|(\\.[eo]g)\\.go|/testdata/|^sql/parser/sql\\.go$|_generated(_test)?\\.go$'" },
                }
              else
                return require("formatter.filetypes.go").gofmt()
              end
            end
          },
          terraform = {
            require("formatter.filetypes.terraform").tofufmt,
          },
          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
          },
        }
      }
    end,
  },
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    dependencies = {
      "rmagatti/logger.nvim",
    },
    cond = function()
      return func.check_global_var("use_goto_preview", true, true)
    end,
    opts = {
      default_mappings = false,
      references = {
        provider = "fzf_lua",
      },
    },
    keys = keymaps.goto_preview.keys,
    config = true,
  },
  {
    "azratul/live-share.nvim",
    dependencies = {
      "jbyuki/instant.nvim",
    },
    cmd = { "LiveShareServer", "LiveShareJoin" },
    cond = function()
      return func.check_global_var("use_live_share", true, true)
    end,
    opts = {
      service = "serveo.net",
    },
    config = function(_, opts)
      vim.g.instant_username = os.getenv("USER")
      require("live-share").setup(opts)
    end,
  },
  {
    "chentoast/marks.nvim",
    event = "BufReadPre",
    cond = function()
      return func.check_global_var("use_marks", true, true)
    end,
    opts = vim.tbl_deep_extend("force", config_opts.marks.opts, {
      default_mappings = false,
    }),
    keys = keymaps.marks.keys,
    config = function(_, opts)
      require("marks").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    cond = function()
      return func.check_global_var("use_autotag", true, true)
    end,
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "tpope/vim-sleuth",
    cond = function()
      return func.check_global_var("use_sleuth", true, true)
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "default" },
        HACK = { icon = " ", color = "warning" },
        WARN = {
          icon = " ",
          color = "warning",
          alt = { "WARNING", "XXX" },
        },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "info", alt = { "INFO", "NB" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      search = {
        pattern = [[\b(KEYWORDS)\s*(\([^\)]*\))?\s*:]],
      },
      highlight = {
        pattern = [[.*<((KEYWORDS)\s*%(\(.{-1,}\))?)\s*:]],
      },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#E06C75" },
        warning = { "DiagnosticWarn", "WarningMsg", "#E5C07B" },
        info = { "DiagnosticInfo", "#54ACE3" },
        hint = { "DiagnosticHint", "#98C379" },
        default = { "#C678DD" },
        test = { "#56B6C2" },
      },
    },
    cond = function()
      return func.check_global_var("use_todo_comments", true, true)
    end,
    config = function(_, opts)
      -- Unfortunately this plugin does not support case insensitivity, so
      -- this is a workaround to add some case insensitivity.
      for key, _ in pairs(opts.keywords) do
        if opts.keywords[key].alt == nil then
          opts.keywords[key].alt = {}
        end

        local oldAlt = vim.tbl_values(opts.keywords[key].alt)
        for _, alt in pairs(oldAlt) do
          table.insert(opts.keywords[key].alt, alt:lower())
          table.insert(opts.keywords[key].alt, alt:capitalize())
        end

        table.insert(opts.keywords[key].alt, key:lower())
        table.insert(opts.keywords[key].alt, key:capitalize())
      end
      require("todo-comments").setup(opts)
    end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    -- This set to false or else yanked text will not be saved until
    -- neoclip is opened.
    lazy = false,
    build = function()
      os.execute("mkdir -p " .. vim.fn.stdpath("data") .. "/databases")
    end,
    dependencies = {
      { "kkharji/sqlite.lua", module = "sqlite" },
      { "ibhagwan/fzf-lua" },
    },
    cond = function()
      return func.check_global_var("use_neoclip", true, true)
    end,
    keys = keymaps.neoclip.keys,
    opts = {
      enable_persistent_history = true,
    },
    config = function(_, opts)
      require("neoclip").setup(opts)
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    cond = function()
      return func.check_global_var("use_mini_surround", true, true)
    end,
    opts = {
      mappings = {
        add = "<S-s>a", -- Add surrounding in Normal and Visual modes
        delete = "<S-s>d", -- Delete surrounding
        find = "<S-s>f", -- Find surrounding (to the right)
        find_left = "<S-s>F", -- Find surrounding (to the left)
        highlight = "<S-s>h", -- Highlight surrounding
        replace = "<S-s>r", -- Replace surrounding
        update_n_lines = "<S-s>n", -- Update `n_lines`

        suffix_last = "",
        suffix_next = "",
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
  {
    "cohama/lexima.vim",
    opts = {
      custom_rules = {
        { char = " ", at = "- (\\%#)", input = ' ', filetype = "norg" },
      }
    },
    cond = function()
      return func.check_global_var("use_auto_pairs", true, true)
    end,
    config = function(_, opts)
      for _, rule in pairs(opts.custom_rules) do
        vim.fn["lexima#add_rule"](rule)
      end
    end,
  },
  {
    "tpope/vim-fugitive",
    cond = function()
      return func.check_global_var("use_fugitive", true, true)
    end,
  },
  {
    "xiyaowong/virtcolumn.nvim",
    cond = function()
      return func.check_global_var("use_virtcolumn", true, true)
    end,
    init = function()
      vim.g.virtcolumn_char = " |"
      vim.g.virtcolumn_priority = 1
    end,
  },
}
