--- @module 'config.keymaps'
--- All the keymappings are defined here.
-- Note: except for autocomplete keymaps, which are found in plugins/cmp.lua

local func = require('util.func')

local M = {}

M.groups = {
  { 'gp', group = 'Goto with preview', icon = { icon = '', color = 'green' } },
  { '<leader>s', group = 'Search' },
  { '<leader>g', group = 'Git', icon = { icon = '', color = 'green' } },
  {'<leader>d', group = 'Debugger', icon = { icon = '󰨰', color = 'blue' } },
  { '<leader><S-t>', group = 'Tests', icon = { icon = '', color = 'blue' } },
  { '<leader>t', group = 'Terminal' },
  { '<leader>m', group = 'Marks', icon = { icon = '', color = 'yellow' }},
  { '<leader>mb', group = 'Bookmarks', icon = { icon = '', color = 'purple' }},
  { '<leader>mbl', group = 'List bookmarks in group [0-9]', icon = { icon = '', color = 'blue' }},
  { '<leader>mb<C-d>', group = 'Delete all bookmarks in group [0-9]', icon = { icon = '󰛌', color = 'red' }},
  { '<leader>m<S-j>', group = 'Next bookmark in group [0-9]', icon = { icon = '󰒭', color = 'green' }},
  { '<leader>m<S-k>', group = 'Previous bookmark in group [0-9]', icon = { icon = '󰒮', color = 'green' }},
  {
    '<leader>l',
    group = function()
      if func.current_buffer_ext_is('octo') then
        return 'GitHub Label'
      end
      return 'LSP'
    end,
    icon = function()
      if func.current_buffer_ext_is('octo') then
        return { icon = '󱍵', color = 'green' }
      end
      return { icon = '', color = 'red' }
    end,
  },
  {
    '<leader>a',
    group = function()
      if func.current_buffer_ext_is('octo') then
        return 'GitHub Assign'
      end
      return 'AI'
    end,
    icon = function()
      if func.current_buffer_ext_is('octo') then
        return { icon = '', color = 'blue' }
      end
      return { icon = '󱚤', color = 'green' }
    end,
  },
  { '<leader>S', group = 'Sessions', icon = { icon = '󰦖', color = 'green' } },
  {
    '<leader>i',
    group = 'GitHub Issue',
    icon = { icon = '', color = 'red' },
  },
  {
    '<leader>p',
    group = 'GitHub PR',
    icon = { icon = '', color = 'orange' },
  },
  {
    '<leader>c',
    group = 'GitHub Comment',
    icon = { icon = '', color = 'blue' },
  },
  {
    '<leader>r',
    group = 'GitHub Reaction',
    icon = { icon = '󰞅', color = 'blue' },
  },
  {
    '<leader>v',
    group = 'GitHub Review',
    icon = { icon = '', color = 'green' },
  },
  {
    '<leader>f',
    group = 'PR File Navigation',
    icon = { icon = '', color = 'blue' },
  },
  {
    '<leader>w',
    group = 'PR Workflow',
    icon = { icon = '', color = 'green' },
  },
}

-- General keymaps that should always be loaded
M.general = {
  keys= {
    {
      '<leader>,',
      ',',
      mode = 'n',
    },
    {
      '<C-w>t',
      '<cmd>tabnew<CR>',
      mode = { 'n', 'i', 'v' },
      desc = 'Create new tab',
    },
    {
      '<C-w>x',
      '<cmd>tabclose<CR>',
      mode = { 'n', 'i', 'v' },
      desc = 'Close tab',
    },
    {
      '<C-w>t',
      '<cmd>tabnew<CR>',
      mode = { 'n', 'i', 'v' },
      desc = 'Create new tab',
    },
    {
      '<C-q>',
      '<cmd>tabn<CR>',
      mode = 'n',
      desc = 'Next tab'
    },
    {
      '<S-q>',
      '<cmd>tabp<CR>',
      mode = 'n',
      desc = 'Previous tab'
    },
    {
      '<S-Up>',
      '<cmd>resize +2<CR>',
      mode = { 'n', 'i', 'v' },
      desc = 'Increase window height'
    },
    {
      '<S-Down>',
      '<cmd>resize -2<CR>',
      mode = { 'n', 'i', 'v' },
      desc = 'Decrease window height'
    },
    {
      '<S-Right>',
      '<cmd>vertical resize +2<CR>',
      mode = { 'n', 'i', 'v' },
      desc = 'Increase window width'
    },
    {
      '<S-Left>',
      '<cmd>vertical resize -2<CR>',
      mode = { 'n', 'i', 'v' },
      desc = 'Decrease window width'
    },
    {
      'q:',
      '<nop>',
      hidden = true,
      mode = 'n'
    },
    --[[
    -- Removing this as it makes using LazyGit annoying.
    -- ]
    {
      '<Esc><Esc>',
      '<C-\\><C-n>',
      mode = 't',
      desc = 'Exit terminal mode',
    },
    --]]
    {
      '<C-w>k',
      '<cmd>wincmd k<CR>',
      mode = 't',
      desc = 'Switch to above window',
    },
    {
      '<C-w>j',
      '<cmd>wincmd j<CR>',
      mode = 't',
      desc = 'Switch to below window',
    },
    {
      '<C-w>l',
      '<cmd>wincmd l<CR>',
      mode = 't',
      desc = 'Switch to right window',
    },
    {
      '<C-w>h',
      '<cmd>wincmd h<CR>',
      mode = 't',
      desc = 'Switch to left window',
    },
  }
}

M.fzf = {
  keys = {
    {
      '<leader>sf',
      '<cmd>FzfLua files<CR>',
      mode = 'n',
      desc = 'Search files'
    },
    {
      '<leader>sb',
      '<cmd>FzfLua buffers<CR>',
      mode = 'n',
      desc = 'Search buffers'
    },
    {
      '<leader>sm',
      '<cmd>FzfLua marks<CR>',
      mode = 'n',
      desc = 'Search marks'
    },
    {
      '<leader>sr',
      '<cmd>FzfLua grep_project<CR>',
      mode = 'n',
      desc = 'Search in project files'
    },
    {
      '<leader>sd',
      '<cmd>FzfLua blines<CR>',
      mode = 'n',
      desc = 'Search in current buffer'
    },
    {
      '<leader>sq',
      '<cmd>FzfLua loclist<CR>',
      mode = 'n',
      desc = 'Search location list',
    },
    {
      '<leader>s<S-q>',
      '<cmd>FzfLua quickfix<CR>',
      mode = 'n',
      desc = 'Search quickfix list',
    },
    {
      '<leader>gc',
      -- Prevent FzF from sorting the output so that local branches
      -- are listed first.
      '<cmd>FzfLua git_branches fzf_opts.--no-sort=true<CR>',
      mode = 'n',
      desc = 'List git branches'
    }
  }
}

M.floaterm = {
  keys = {
    {
      '<leader>t',
      '<cmd>FloatermToggle<CR>',
      mode = 'n',
      desc = 'Toggle terminal'
    },
    {
      '<leader>t',
      '<C-\\><C-n><cmd>FloatermToggle<CR>',
      mode = 't',
      desc = 'Toggle terminal'
    },
    {
      '<leader>n',
      '<C-\\><C-n><cmd>FloatermNew<CR>',
      mode = 't',
      desc = 'New terminal'
    },
    {
      '<leader>l',
      '<C-\\><C-n><cmd>FloatermNext<CR>',
      mode = 't',
      desc = 'Next terminal'
    },
    {
      '<leader>h',
      '<C-\\><C-n><cmd>FloatermPrev<CR>',
      mode = 't',
      desc = 'Previous terminal'
    }
  }
}

M.nvim_tree = {
  keys = {
    {
      '<C-n>',
      '<cmd>NvimTreeFocus<CR>',
      mode = 'n',
      desc = 'Focus on nvim-tree'
    },
    {
      '<C-b>',
      '<cmd>NvimTreeToggle<CR>',
      mode = 'n',
      desc = 'Toggle nvim-tree'
    },
    {
      '<C-f>',
      '<cmd>NvimTreeFindFile<CR>',
      mode = 'n',
      desc = 'Find file in nvim-tree'
    }
  }
}

M.lsp = {
  keys = {
    {
      'gd',
      '<cmd>FzfLua lsp_definitions<CR>',
      mode = 'n',
      desc = 'Go to definition'
    },
    {
      'gi',
      '<cmd>FzfLua lsp_implementations<CR>',
      mode = 'n',
      desc = 'List implementations'
    },
    {
      'gr',
      '<cmd>FzfLua lsp_references<CR>',
      mode = 'n',
      desc = 'List references'
    },
    {
      'gt',
      '<cmd>FzfLua lsp_typedefs<CR>',
      mode = 'n',
      desc = 'Go to type definition'
    },
    {
      '<F2>',
      '<cmd>lua vim.lsp.buf.rename()<CR>',
      mode = 'n',
      desc = 'Rename reference'
    },
    {
      '<C-k>',
      '<cmd>lua vim.lsp.buf.hover()<CR>',
      mode = 'n',
      desc = 'Show documentation'
    },
    {
      '<C-k>',
      '<cmd>lua vim.lsp.buf.signature_help()<CR>',
      mode = 'i',
      desc = 'Show signature'
    },
    {
      '<leader>ld',
      '<cmd>FzfLua diagnostics_document<CR>',
      mode = 'n',
      desc = 'Show buffer diagnostics'
    },
    {
      '<leader>l<S-d>',
      '<cmd>FzfLua diagnostics_workspace<CR>',
      mode = 'n',
      desc = 'Show workspace diagnostics'
    },
    {
      '<leader>lj',
      '<cmd>lua vim.diagnostic.goto_next()<CR>',
      mode = 'n',
      desc = 'Next diagnostic'
    },
    {
      '<leader>lk',
      '<cmd>lua vim.diagnostic.goto_prev()<CR>',
      mode = 'n',
      desc = 'Previous diagnostic'
    },
    {
      '<leader>lc',
      '<cmd>FzfLua lsp_code_actions<CR>',
      mode = 'n',
      desc = 'Code actions'
    },
    {
      '<leader>l<S-s>',
      '<cmd>FzfLua lsp_live_workspace_symbols<CR>',
      mode = 'n',
      desc = 'Live workspace symbols'
    },
    {
      '<leader>ls',
      '<cmd>FzfLua treesitter<CR>',
      mode = 'n',
      desc = 'List buffer symbols'
    },
    {
      '<leader>lh',
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}), {0})
      end,
      mode = 'n',
      desc = 'Toggle inlay hints'
    }
  }
}

M.dap = {
  keys = {
    {
      '<leader>db',
      '<cmd>DapToggleBreakpoint<CR>',
      mode = 'n',
      desc = 'Toggle breakpoint'
    },
    {
      '<leader>dfb',
      '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
      mode = 'n',
      desc = 'Set conditional breakpoint'
    },
    {
      '<leader>dlb',
      '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
      mode = 'n',
      desc = 'Set log breakpoint'
    },
    {
      '<leader>dc',
      '<cmd>DapContinue<CR>',
      mode = 'n',
      desc = '[Debugger] Continue'
    },
    {
      '<leader>ds',
      '<cmd>DapStepOver<CR>',
      mode = 'n',
      desc = '[Debugger] Step over',
    },
    {
      '<leader>di',
      '<cmd>DapStepInto<CR>',
      mode = 'n',
      desc = '[Debugger] Step into'
    },
    {
      '<leader>do',
      '<cmd>DapStepOut<CR>',
      mode = 'n',
      desc = '[Debugger] Step out'
    },
    {
      '<leader>dd',
      '<cmd>DapDisconnect<CR>',
      mode = 'n',
      desc = '[Debugger] Disconnect'
    },
    {
      '<leader>dx',
      '<cmd>DapTerminate<CR>',
      mode = 'n',
      desc = '[Debugger] Terminate'
    },
    -- Since I'm always going to be using dap-ui with dap, I'm going to include
    -- dap-ui keymaps in the dap keymaps.
    {
      '<leader>du',
      '<cmd>lua require(\'dapui\').toggle()<CR>',
      mode = 'n',
      desc = 'Toggle dap-ui'
    },
    {
      '<leader>de',
      '<cmd>lua require(\'dapui\').eval(vim.fn.input("Evaluate expression: "))<CR>',
      mode = 'n',
      desc = 'Evaluate expression'
    },
  }
}

M.dapgo = {
  keys = {
    {
      '<leader>dtt',
      '<cmd>lua require("dap-go").debug_test()<CR>',
      mode = 'n',
      desc = 'Debug nearest test'
    },
    {
      '<leader>dtl',
      '<cmd>lua require("dap-go").debug_last_test()<CR>',
      mode = 'n',
      desc = 'Debug last test'
    },
  }
}

M.whichkey = {
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = true })
      end,
      mode = 'n',
      desc = 'Show keymaps'
    }
  }
}

M.test = {
  keys = {
    {
      '<leader><S-t>s',
      '<cmd>TestSuite<CR>',
      mode = 'n',
      desc = 'Run test suite'
    },
    {
      '<leader><S-t>f',
      '<cmd>TestFile<CR>',
      mode = 'n',
      desc = 'Run test file'
    },
    {
      '<leader><S-t>t',
      '<cmd>TestNearest<CR>',
      mode = 'n',
      desc = 'Run nearest test'
    },
    {
      '<leader><S-t>l',
      '<cmd>TestLast<CR>',
      mode = 'n',
      desc = 'Run last test'
    },
    {
      '<leader><S-t>g',
      '<cmd>TestVisit<CR>',
      mode = 'n',
      desc = 'Go to last test'
    },
  }
}

M.code_companion = {
  keys = {
    {
      '<leader>aa',
      '<cmd>CodeCompanionActions<CR>',
      mode = { 'n', 'x' },
      desc = 'Code companion actions',
    },
  }
}

M.nvim_possession = {
  keys = {
    {
      '<leader>Sl',
      function()
        require('nvim-possession').list()
      end,
      mode = 'n',
      desc = 'List sessions'
    },
    {
      '<leader>Sn',
      function()
        require('nvim-possession').new()
      end,
      mode = 'n',
      desc = 'New session'
    },
    {
      '<leader>Su',
      function()
        require('nvim-possession').update()
      end,
      mode = 'n',
      desc = 'Update session'
    },
    {
      '<leader>Sd',
      function()
        require('nvim-possession').delete()
      end,
      mode = 'n',
      desc = 'Delete session'
    }
  }
}

M.neoscroll = {
  keys = {
    {
      '<C-y>',
      function()
          require('neoscroll').scroll(-1, {
            move_cursor = false,
            easing = nil,
            duration = 0,
          })
      end,
      mode = { 'n', 'v', 'x' },
      desc = 'Scroll up 1 line',
    },
    {
      '<C-e>',
      function()
          require('neoscroll').scroll(1, {
            move_cursor = false,
            easing = nil,
            duration = 0,
          })
      end,
      mode = { 'n', 'v', 'x' },
      desc = 'Scroll down 1 line',
    }
  }
}

M.copilot = {
  keys = {
    {
      '<C-l>',
      function()
        local copilot = require('copilot.suggestion')
        if copilot.is_visible() then
          copilot.accept()
        end
      end,
      mode = 'i',
      desc = 'Accept Copilot suggestion'
    },
  }
}

M.fugitive = {
  keys = {
    {
      -- Visual mode selection marks are only set AFTER leaving visual mode.
      -- <Cmd> keeps you in the same mode, so we have to use : instead, which
      -- exits you from visual mode.
      '<leader>gl',
      ":'<,'>GBrowse!<CR>",
      mode = 'x',
      desc = 'Copy GitHub URL for selection',
    },
  },
}

M.gitsigns = {
  keys = {
    {
      '<leader>gs',
      '<cmd>Gitsigns toggle_signs<CR>',
      mode = 'n',
      desc = 'Toggle show Git signs',
    },
    {
      '<leader>gd',
      '<cmd>Gitsigns toggle_word_diff<CR>',
      mode = 'n',
      desc = 'Toggle intra-line word-diff for this buffer',
    },
    {
      '<leader>g<S-b>',
      '<cmd>Gitsigns blame<CR>',
      mode = 'n',
      desc = 'Show Git blame',
    },
    {
      '<leader>gb',
      '<cmd>Gitsigns blame_line<CR>',
      mode = 'n',
      desc = 'Show Git blame for current line',
    },
  }
}

M.neoclip = {
  keys = {
    {
      '<leader>sy',
      function()
        require('neoclip.fzf')()
      end,
      mode = 'n',
      desc = 'Search clipboard history'
    }
  }
}

M.lazygit = {
  keys = {
    {
      '<leader>gg',
      '<cmd>LazyGit<CR>',
      mode = 'n',
      desc = 'Open LazyGit',
    }
  }
}

M.octo = {
  keys = {
    {
      '<leader>gi',
      '<cmd>Octo issue list<CR>',
      mode = 'n',
      desc = 'List open issues'
    },
    {
      '<leader>gp',
      '<cmd>Octo pr list<CR>',
      mode = 'n',
      desc = 'List open PRs'
    },
    {
      '<leader>pw',
      '<cmd>Octo pr runs<CR>',
      mode = 'n',
      desc = 'List PR workflow runs',
      ft = 'octo',
    },
  },
  -- Octo mode specific keymaps
  mappings = {
    runs = {
      expand_step = { lhs = "<CR>", desc = "expand workflow step" },
      open_in_browser = { lhs = "<leader>wb", desc = "open workflow run in browser" },
      refresh = { lhs = "<C-r>", desc = "refresh workflow" },
      rerun = { lhs = "<leader>wrr", desc = "rerun workflow" },
      rerun_failed = { lhs = "<leader>wrf", desc = "rerun failed workflow" },
      cancel = { lhs = "<leader>wx", desc = "cancel workflow" },
      copy_url = { lhs = "<leader>wy", desc = "copy url to system clipboard" },
    },
    issue = {
      close_issue = { lhs = "<leader>ic", desc = "close issue" },
      reopen_issue = { lhs = "<leader>io", desc = "reopen issue" },
      list_issues = { lhs = "<leader>il", desc = "list open issues on same repo" },
      reload = { lhs = "<C-r>", desc = "reload issue" },
      open_in_browser = { lhs = "<leader>ib", desc = "open issue in browser" },
      copy_url = { lhs = "<leader>iy", desc = "copy url to clipboard" },
      add_assignee = { lhs = "<leader>aa", desc = "add assignee" },
      remove_assignee = { lhs = "<leader>ad", desc = "remove assignee" },
      create_label = { lhs = "<leader>lc", desc = "create label" },
      add_label = { lhs = "<leader>la", desc = "add label" },
      remove_label = { lhs = "<leader>ld", desc = "remove label" },
      add_comment = { lhs = "<leader>ca", desc = "add comment" },
      delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
      next_comment = { lhs = "<leader>cj", desc = "go to next comment" },
      prev_comment = { lhs = "<leader>ck", desc = "go to previous comment" },
      react_hooray = { lhs = "<leader>rp", desc = "add/remove 󱁖 reaction" },
      react_heart = { lhs = "<leader>rh", desc = "add/remove  reaction" },
      react_eyes = { lhs = "<leader>re", desc = "add/remove  reaction" },
      react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove  reaction" },
      react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove  reaction" },
      react_rocket = { lhs = "<leader>rr", desc = "add/remove 󱓞 reaction" },
      react_laugh = { lhs = "<leader>rl", desc = "add/remove  reaction" },
      react_confused = { lhs = "<leader>rc", desc = "add/remove  reaction" },
    },
    pull_request = {
      checkout_pr = { lhs = "<leader>pc", desc = "checkout PR" },
      merge_pr = { lhs = "<leader>pm", desc = "merge commit PR" },
      squash_and_merge_pr = { lhs = "<leader>psm", desc = "squash and merge PR" },
      rebase_and_merge_pr = { lhs = "<leader>prm", desc = "rebase and merge PR" },
      list_commits = { lhs = "<leader>pC", desc = "list PR commits" },
      list_changed_files = { lhs = "<leader>pf", desc = "list PR changed files" },
      show_pr_diff = { lhs = "<leader>pd", desc = "show PR diff" },
      add_reviewer = { lhs = "<leader>ar", desc = "add reviewer" },
      remove_reviewer = { lhs = "<leader>ard", desc = "remove reviewer request" },
      close_issue = { lhs = "<leader>p<C-c>", desc = "close PR" },
      reopen_issue = { lhs = "<leader>po", desc = "reopen PR" },
      reload = { lhs = "<C-r>", desc = "reload PR" },
      open_in_browser = { lhs = "<leader>pb", desc = "open PR in browser" },
      copy_url = { lhs = "<leader>py", desc = "copy url to clipboard" },
      goto_file = { lhs = "<leader>fg", desc = "go to file" },
      add_assignee = { lhs = "<leader>aa", desc = "add assignee" },
      remove_assignee = { lhs = "<leader>ad", desc = "remove assignee" },
      create_label = { lhs = "<leader>lc", desc = "create label" },
      add_label = { lhs = "<leader>la", desc = "add label" },
      remove_label = { lhs = "<leader>ld", desc = "remove label" },
      add_comment = { lhs = "<leader>ca", desc = "add comment" },
      delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
      next_comment = { lhs = "<leader>cj", desc = "go to next comment" },
      prev_comment = { lhs = "<leader>ck", desc = "go to previous comment" },
      react_hooray = { lhs = "<leader>rp", desc = "add/remove 󱁖 reaction" },
      react_heart = { lhs = "<leader>rh", desc = "add/remove  reaction" },
      react_eyes = { lhs = "<leader>re", desc = "add/remove  reaction" },
      react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove  reaction" },
      react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove  reaction" },
      react_rocket = { lhs = "<leader>rr", desc = "add/remove 󱓞 reaction" },
      react_laugh = { lhs = "<leader>rl", desc = "add/remove  reaction" },
      react_confused = { lhs = "<leader>rc", desc = "add/remove  reaction" },
      review_start = { lhs = "<leader>vv", desc = "start a review for the current PR" },
      review_resume = { lhs = "<leader>vr", desc = "resume a pending review for the current PR" },
      resolve_thread = { lhs = "<leader>ptr", desc = "resolve PR thread" },
      unresolve_thread = { lhs = "<leader>ptR", desc = "unresolve PR thread" },
    },
    review_thread = {
      add_comment = { lhs = "<leader>ca", desc = "add comment" },
      add_suggestion = { lhs = "<leader>cs", desc = "add suggestion" },
      delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
      next_comment = { lhs = "<leader>cj", desc = "go to next comment" },
      prev_comment = { lhs = "<leader>ck", desc = "go to previous comment" },
      select_next_entry = { lhs = "<leader>fj", desc = "move to next changed file" },
      select_prev_entry = { lhs = "<leader>fk", desc = "move to previous changed file" },
      select_first_entry = { lhs = "<leader>fK", desc = "move to first changed file" },
      select_last_entry = { lhs = "<leader>fJ", desc = "move to last changed file" },
      close_review_tab = { lhs = "<leader>vx", desc = "close review tab" },
      react_hooray = { lhs = "<leader>rp", desc = "add/remove 󱁖 reaction" },
      react_heart = { lhs = "<leader>rh", desc = "add/remove  reaction" },
      react_eyes = { lhs = "<leader>re", desc = "add/remove  reaction" },
      react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove  reaction" },
      react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove  reaction" },
      react_rocket = { lhs = "<leader>rr", desc = "add/remove 󱓞 reaction" },
      react_laugh = { lhs = "<leader>rl", desc = "add/remove  reaction" },
      react_confused = { lhs = "<leader>rc", desc = "add/remove  reaction" },
      resolve_thread = { lhs = "<leader>ptr", desc = "resolve PR thread" },
      unresolve_thread = { lhs = "<leader>ptR", desc = "unresolve PR thread" },
    },
    submit_win = {
      approve_review = { lhs = "<leader>vsa", desc = "approve review", mode = { "n", "i" } },
      comment_review = { lhs = "<leader>vsm", desc = "comment review", mode = { "n", "i" } },
      request_changes = { lhs = "<leader>vsc", desc = "request changes review", mode = { "n", "i" } },
      close_review_tab = { lhs = "<leader>vx", desc = "close review tab", mode = { "n", "i" } },
    },
    review_diff = {
      submit_review = { lhs = "<leader>vs", desc = "submit review" },
      discard_review = { lhs = "<leader>vd", desc = "discard review" },
      add_review_comment = { lhs = "<leader>ca", desc = "add a new review comment", mode = { "n", "x" } },
      add_review_suggestion = { lhs = "<leader>cs", desc = "add a new review suggestion", mode = { "n", "x" } },
      focus_files = { lhs = "<leader>fn", desc = "move focus to changed file panel" },
      toggle_files = { lhs = "<leader>fb", desc = "hide/show changed files panel" },
      next_thread = { lhs = "<leader>vtj", desc = "move to next thread" },
      prev_thread = { lhs = "<leader>vtk", desc = "move to previous thread" },
      select_next_entry = { lhs = "<leader>fj", desc = "move to next changed file" },
      select_prev_entry = { lhs = "<leader>fk", desc = "move to previous changed file" },
      select_first_entry = { lhs = "<leaderfK", desc = "move to first changed file" },
      select_last_entry = { lhs = "<leader>fJ", desc = "move to last changed file" },
      close_review_tab = { lhs = "<leader>vx", desc = "close review tab" },
      toggle_viewed = { lhs = "<leader>v<space>", desc = "toggle viewer viewed state" },
      goto_file = { lhs = "<leader>fg", desc = "go to file" },
    },
    file_panel = {
      submit_review = { lhs = "<leader>vs", desc = "submit review" },
      discard_review = { lhs = "<leader>vd", desc = "discard review" },
      next_entry = { lhs = "<leader>fj", desc = "move to next changed file" },
      prev_entry = { lhs = "<leader>fk", desc = "move to previous changed file" },
      select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
      refresh_files = { lhs = "<C-r>", desc = "refresh changed files panel" },
      focus_files = { lhs = "<leader>fn", desc = "move focus to changed file panel" },
      toggle_files = { lhs = "<leader>fb", desc = "hide/show changed files panel" },
      select_first_entry = { lhs = "<leader>fK", desc = "move to first changed file" },
      select_last_entry = { lhs = "<leader>fJ", desc = "move to last changed file" },
      close_review_tab = { lhs = "<leader>vx", desc = "close review tab" },
      toggle_viewed = { lhs = "<leader>v<space>", desc = "toggle viewer viewed state" },
    },
  }
}

M.marks = {
  keys = {
    {
      '<leader>ml',
      function()
        vim.cmd('MarksListBuf')
        vim.cmd('lclose')
        vim.cmd('FzfLua loclist')
      end,
      mode = 'n',
      desc = 'List marks in buffer',
    },
    {
      '<leader>m<S-l>',
      function()
        vim.cmd('MarksListAll')
        vim.cmd('lclose')
        vim.cmd('FzfLua loclist')
      end,
      mode = 'n',
      desc = 'List all marks in open buffers',
    },
    {
      '<leader>m<C-l>',
      function()
        vim.cmd('MarksListGlobal')
        vim.cmd('lclose')
        vim.cmd('FzfLua loclist')
      end,
      mode = 'n',
      desc = 'List all global marks',
    },
    {
      '<leader>mp',
      '<Plug>(Marks-preview)',
      mode = 'n',
      desc = 'Preview specific mark'
    },
    {
      '<leader>m,',
      '<Plug>(Marks-setnext)',
      mode = 'n',
      desc = 'Set next alphabetical (lowercase) mark'
    },
    {
      '<leader>m;',
      '<Plug>(Marks-toggle)',
      mode = 'n',
      desc = 'Toggle next available mark on current line'
    },
    {
      '<leader>md',
      '<Plug>(Marks-delete)',
      mode = 'n',
      desc = 'Delete specific mark'
    },
    {
      '<leader>m<S-d>',
      '<Plug>(Marks-deleteline)',
      mode = 'n',
      desc = 'Delete all marks under cursor'
    },
    {
      '<leader>m<C-d>',
      '<Plug>(Marks-deletebuf)',
      mode = 'n',
      desc = 'Delete marks in buffer'
    },
    {
      '<leader>mj',
      '<Plug>(Marks-next)',
      mode = 'n',
      desc = 'Next mark',
    },
    {
      '<leader>mk',
      '<Plug>(Marks-prev)',
      mode = 'n',
      desc = 'Previous mark',
    },
    {
      '<leader>mbL',
      function()
        vim.cmd('BookmarksListAll')
        vim.cmd('lclose')
        vim.cmd('FzfLua loclist')
      end,
      mode = 'n',
      desc = 'List all bookmarks',
    },
    {
      '<leader>mba',
      function()
        require('marks').annotate()
      end,
      mode = 'n',
      desc = 'Annotate bookmark under cursor',
    },
    {
      '<leader>mb<S-d>',
      '<Plug>(Marks-delete-bookmark)',
      mode = 'n',
      desc = 'Delete bookmark under cursor',
    },
    {
      '<leader>mb?',
      function()
        local opts = require('config.opts').marks.opts
        local help_table = {}
        for i = 0, 9 do
          local group = opts['bookmark_'..i]
          if group.virt_text == nil then
            goto continue
          end
          table.insert(help_table, '[' .. i .. '] ' .. group.sign .. ' : ' .. group.virt_text)
          ::continue::
        end
        local max_text_length = 0
        for _, line in ipairs(help_table) do
          max_text_length = math.max(max_text_length, #line)
        end
        func.display_in_float(
          help_table,
          #help_table,
          math.min(max_text_length * 2, 80),
          {
            title = 'Named Bookmark Groups (q to close)',
          }
        )
      end,
      mode = 'n',
      desc = 'Show bookmark group info'
    }
  }
}
for i = 0, 9 do
  local opts = require('config.opts').marks.opts
  local group = opts['bookmark_'..i]
  local group_name = group.sign
  if group.virt_text ~= nil then
    group_name = group_name .. ' : ' .. group.virt_text
  end
  table.insert(M.marks.keys, {
    '<leader>mb' .. i,
    function()
      require('marks').bookmark_state:place_mark(i)
    end,
    mode = 'n',
    desc = 'Add to ' .. group_name
  })
  table.insert(M.marks.keys, {
    '<leader>mbl' .. i,
    function()
      vim.cmd('BookmarksList '.. i)
      vim.cmd('lclose')
      vim.cmd('FzfLua loclist')
    end,
    mode = 'n',
    desc = group_name
  })
  table.insert(M.marks.keys, {
    '<leader>mb<C-d>' .. i,
    function()
      require('marks').bookmark_state:delete_all(i)
    end,
    mode = 'n',
    desc = group_name
  })
  table.insert(M.marks.keys, {
    '<leader>m<S-j>' .. i,
    function()
      require('marks').bookmark_state:next(i)
    end,
    mode = 'n',
    desc = group_name
  })
  table.insert(M.marks.keys, {
    '<leader>m<S-k>' .. i,
    function()
      require('marks').bookmark_state:prev(i)
    end,
    mode = 'n',
    desc = group_name
  })
end

M.goto_preview = {
  keys = {
    {
      'gpd',
      function()
        require('goto-preview').goto_preview_definition()
      end,
      mode = 'n',
      desc = 'Goto definition with preview',
    },
    {
      'gpt',
      function()
        require('goto-preview').goto_preview_type_definition()
      end,
      mode = 'n',
      desc = 'Goto type definition with preview',
    },
    {
      'gpi',
      function()
        require('goto-preview').goto_preview_implementation()
      end,
      mode = 'n',
      desc = 'Goto implementation with preview',
    },
    {
      'gpr',
      function()
        require('goto-preview').goto_preview_references()
      end,
      mode = 'n',
      desc = 'Goto references with preview',
    },
    {
      'gpq',
      function()
        require('goto-preview').close_all_win()
      end,
      mode = 'n',
      desc = 'Close all preview windows',
    }
  }
}

return M
