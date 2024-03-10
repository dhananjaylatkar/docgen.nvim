local utils = require("docgen.utils")

local M = {}

-- default format for each supported language
M.opts = {
  c = "doxygen",
}

M.docs_gen = function(args)
  local ft = vim.bo.filetype

  local ok, parser = pcall(require, "docgen.parsers." .. ft)
  if not ok then
    vim.notify("DocGen: not available for '" .. ft .. "'")
    return
  end

  -- use doc format passed in by cmd
  M.opts["_custom"] = args[1]

  utils.insert_doc(parser.get_doc, M.opts)
end

M.setup = function(opts)
  opts = opts or {}
  M.opts = vim.tbl_deep_extend("force", M.opts, opts)

  vim.api.nvim_create_user_command("DocGen", function(cmd_opts)
    M.docs_gen(cmd_opts.fargs)
  end, {
    nargs = "*",
    complete = function(_, line)
      local cmds = { "doxygen" }
      local l = vim.split(line, "%s+")
      local n = #l - 2

      if n == 0 then
        return vim.tbl_filter(function(val)
          return vim.startswith(val, l[2])
        end, cmds)
      end
    end,
  })
end

return M
