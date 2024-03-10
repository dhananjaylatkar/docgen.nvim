# docgen.nvim

Generate function docs using treesitter

[docgen.nvim.webm](https://github.com/dhananjaylatkar/docgen.nvim/assets/27724944/e560572e-7539-4b26-b8e2-2d899cbde877)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua

{
  "dhananjaylatkar/docgen.nvim",
  dependencies = {
    {
    -- make sure parser for your language is installed
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "c" },
        })
      end,
      run = ":TSUpdate",
    }
  },
  opts = {
    -- USE EMPTY FOR DEFAULT OPTIONS
    -- DEFAULTS ARE LISTED BELOW
  },
}
```

## Configuration

_**You must run `require("docgen").setup()` to initialize the plugin.**_

_docgen.nvim_ comes with following defaults:

```lua
-- default doc format for each supported language
{
  c = "doxygen",
}
```

## Commands

| Command            | Action                                                   |
| ------------------ | -------------------------------------------------------- |
| `:DocGen`          | Insert doc for function in scope using configured format |
| `:DocGen <format>` | Insert doc for function in scope using given format      |

## Contributing

You can add support for your language or format easily.

### Adding new language support

1. Create `lua/parsers/<lang>.lua`
2. Expose `get_doc()` which shall return a table as follows -

```lua
{
  start_line = "<start pos of doc>",
  comment = "<list of doc comments>"
}
```

### Adding new doc format

In `lua/parsers/<lang>.lua` add `else` condition in `get_doc()` for `doc_format`.
