# Kevin's Neovim Config

## Configuration

### Local Config

To facilitate copying this Neovim configuration across multiple machines with
different workflows and binary paths, this configuration loads from a
git-ignored `local.lua` in [`lua/config/`](/lua/config).

You can find the configuration schema of this local configuration in
[`lua/util/config.lua`](/lua/util/config.lua). It is highly recommended that the
returned configuration in your `local.lua` is typed with `@type LocalConfig` to
get type hinting.

### LSP Features

If you wish to add support for some language to this configuration, create a
corresponding file in [`lua/plugins/lang/lsp/`](/lua/plugins/lang/lsp). The
returned spec should be of type `LspSpec` (defined in
[`lua/plugins/lang/lsp/lsp.lua`](/lua/plugins/lang/lsp/lsp.lua)). This allows
you to install per-language plugins and configure `nvim-lsp-config` while
keeping the plugins organized per language.

## Dependencies

This is a set of dependencies for the plugins in this configuration. It is not
an exhaustive list, but does contain a majority of requirements.

- nvim 0.11+
- A lot of plugins required [patched fonts](https://www.nerdfonts.com/), so install them.
- nvim-dap-go
    - delve
- copilot.vim
    - curl
- nvim-treesitter
    - C compiler
    - libstdc++
    - git
    - tar/curl
- fzf
    - fzf
    - ripgrep
- neoclip
    - sqlite3 if you want to use persistent history
- lazygit
    - [LazyGit CLI tool](https://github.com/jesseduffield/lazygit)
- octo
    - [Github CLI](https://cli.github.com/)
- claude code
    - [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code/setup)
- opencode
    -[OpenCode CLI](https://opencode.ai)
- nvim-lint
    - [golangci-lint](https://golangci-lint.run/docs/welcome/install/)
- obsidian.nvim
    - For pasting images from the clipboard:
        - For MacOS: `pngpaste` (`brew install pngpaste`)
        - For Linux: `xclip` for `X11` or `wl-clipboard` for `Wayland`
