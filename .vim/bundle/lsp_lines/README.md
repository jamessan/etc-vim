# lsp_lines.nvim

[Source](https://git.sr.ht/~whynothugo/lsp_lines.nvim) |
[Issues](https://todo.sr.ht/~whynothugo/lsp_lines.nvim) |
[Discussion/Patches](https://lists.sr.ht/~whynothugo/lsp_lines.nvim) |
[Chat](irc://ircs.libera.chat:6697/#whynothugo) |
[Sponsor](https://whynothugo.nl/sponsor/)

`lsp_lines` is a simple neovim plugin that renders diagnostics using virtual
lines on top of the real line of code.

![A screenshot of the plugin in action](screenshot.png)

Font is [Fira Code][font], a classic.
Theme is [tokyonight.nvim][theme].

[font]: https://github.com/tonsky/FiraCode
[theme]: https://github.com/folke/tokyonight.nvim

# Background

LSPs provide lots of useful diagnostics for code (typically: errors, warnings,
linting). By default they're displayed using virtual text at the end of the
line which in some situations might be good enough, but often the diagnostic
simply doesn't fit on screen. It's also quite common to have more than one
diagnostic per line, but there's no way to view more than the first.

`lsp_lines` solves this issue.

# Installation

## With packer.nvim

Using packer.nvim (this should probably be registered _after_ `lspconfig`):

```lua
use({
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()
  end,
})
```

## With git

You can algo just clone the repo into neovim's plug-in directory:

    mkdir -p $HOME/.local/share/nvim/site/pack/plugins/start/
    cd $HOME/.local/share/nvim/site/pack/plugins/start/
    git clone git@git.sr.ht:~whynothugo/lsp_lines.nvim

And then in `init.lua`:

    require("lsp_lines").setup()

# Setup

It's recommended to also remove the regular virtual text diagnostics to avoid
pointless duplication:

```lua
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})
```

# Usage

This plugin's functionality can be disabled with:

```lua
vim.diagnostic.config({ virtual_lines = false })
```

And it can be re-enabled via:

```lua
vim.diagnostic.config({ virtual_lines = true })
```

To show virtual lines only for the current line's diagnostics:

```lua
vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
```

If you don't want to highlight the entire diagnostic line, use:

```lua
vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false } })
```

A helper is also provided to toggle, which is convenient for mappings:

```lua
vim.keymap.set(
  "",
  "<Leader>l",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)
```

# Development

It would be nice to show connecting lines when there's relationship between
diagnostics (as is the case with `rust_analyzer`). Or perhaps surface them via
`vim.lsp.buf.hover`.

# Licence

This project is licensed under the ISC licence. See LICENCE for more details.
