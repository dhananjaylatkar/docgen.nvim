local utils = require("docgen.utils")

local M = {}

local function get_func_info()
  local method_node = utils.get_func_node("function_definition")

  if not method_node then
    return
  end

  local query = vim.treesitter.query.parse(
    "c",
    [[
      (function_definition
        declarator: (function_declarator
          declarator: (identifier) @func.name
          parameters: (parameter_list
            (parameter_declaration
              declarator:
              (_)
            )
          )@func.params
        )
      ) @func
    ]]
  )

  for _, match in query:iter_matches(method_node, 0) do
    local fun_name = vim.treesitter.get_node_text(match[1], 0)
    local param_node = match[2]
    local param_info = {}
    for param in param_node:iter_children() do
      if param:type() == "parameter_declaration" then
        table.insert(param_info, {
          type = vim.treesitter.get_node_text(param:field("type")[1], 0),
          name = vim.treesitter.get_node_text(param:field("declarator")[1], 0),
        })
      end
    end

    return {
      name = fun_name,
      param_info = param_info,
      start_pos = method_node:start(),
    }
  end
end

M.get_doc = function(opts)
  local res = {}
  res.comment = {}
  local doc_format = opts._custom or opts.c
  local method_info = get_func_info()

  if not method_info then
    return nil
  end

  local tab_space = utils.get_indent_padding(method_info.start_pos)
  res.start_pos = method_info.start_pos

  if doc_format == "doxygen" then
    utils.add_line(res.comment, tab_space, "/**")
    utils.add_line(res.comment, tab_space, string.format(" * @brief "))

    utils.add_line(res.comment, tab_space, " *")

    for _, param in ipairs(method_info.param_info) do
      utils.add_line(res.comment, tab_space, string.format(" * @param %s [in]", param.name))
    end

    utils.add_line(res.comment, tab_space, " *")
    utils.add_line(res.comment, tab_space, string.format(" * @return"))
    utils.add_line(res.comment, tab_space, " */")
    utils.add_line(res.comment, tab_space, "")
  elseif doc_format == "kernel_doc" then
    utils.add_line(res.comment, tab_space, "/**")
    utils.add_line(res.comment, tab_space, string.format(" * %s() - ", method_info.name))
    for _, param in ipairs(method_info.param_info) do
      utils.add_line(res.comment, tab_space, string.format(" * @%s:", param.name))
    end
    utils.add_line(res.comment, tab_space, " *")
    utils.add_line(res.comment, tab_space, " * Context:")
    utils.add_line(res.comment, tab_space, " * Return:")
    utils.add_line(res.comment, tab_space, " */")
    utils.add_line(res.comment, tab_space, "")
  else
    vim.notify("DocGen: doc_format=" .. doc_format .. " is not implemented for 'c'")
    return nil
  end

  res.ins_pos = res.start_pos + 2
  return res
end

return M
