# docgen.nvim

Generate function docs using treesitter

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{

  "dhananjaylatkar/docgen.nvim",
  dependencies = {
      "nvim-treesitter/nvim-treesitter",
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
