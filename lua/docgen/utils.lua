local ts_utils = require("nvim-treesitter.ts_utils")
local ts_locals = require("nvim-treesitter.locals")
local ts_indent = require("nvim-treesitter.indent")

local M = {}

M.get_func_node = function(func_ident)
  local curr_node = ts_utils.get_node_at_cursor()
  local scope = ts_locals.get_scope_tree(curr_node, 0)
  local method_node = nil

  for _, node in ipairs(scope) do
    if node:type() == func_ident then
      method_node = node
    end
  end

  return method_node
end

M.get_indent_padding = function(line)
  local indent_count = ts_indent.get_indent(line)

  if indent_count == 0 then
    return ""
  end

  local get_opt = vim.api.nvim_get_option_value
  local tabstop = get_opt("tabstop", {})
  local ntabs = (indent_count / tabstop)
  local tab_space = ""

  if get_opt("expandtab", {}) then
    tab_space = string.rep(" ", tabstop * ntabs)
  else
    tab_space = string.rep("\t", ntabs)
  end

  return tab_space
end

M.add_line = function(comment_lines, tab_space, line)
  table.insert(comment_lines, tab_space .. line)
end

M.insert_doc = function(get_doc, opts)
  local doc = get_doc(opts)

  if not doc or not doc.comment then
    return
  end

  vim.api.nvim_buf_set_text(0, doc.start_pos, 0, doc.start_pos, 0, doc.comment)
  vim.api.nvim_win_set_cursor(0, {doc.ins_pos, 0})
  vim.cmd([[ startinsert! ]])
end

return M
