local lsp_handlers = vim.lsp.handlers
local lsp_util = vim.lsp.util
local lsp_buf = vim.lsp.buf
local diagnostic_util = require'autofix_nvim.diagnostic'
local M = {}

local function apply_code_action(action)
  -- XXX duplicated neovim logic from the default codeAction handler
  if action.edit or type(action.command) == "table" then
    if action.edit then
      lsp_util.apply_workspace_edit(action.edit)
    end
    if type(action.command) == "table" then
      lsp_buf.execute_command(action.command)
    end
  else
    lsp_buf.execute_command(action.command)
  end
end

-- @return decorator for the textDocument/codeAction handler
-- Before applying the default code action, find a handler for the action's source and diagnostics code.
-- If one exists, apply the code action automatically. Otherwise, apply the default handler.
function M.get_autofix_code_action_handler()
  local default_code_action_handler = lsp_handlers['textDocument/codeAction']
  return function(...)
    local actions = select(3, ...) or {}
    for _, action in ipairs(actions) do
      local diagnostics = action.diagnostics or {}
      for _, diagnostic in ipairs(diagnostics) do
        local autofix_handler = diagnostic_util.get_autofix_handler(diagnostic)
        if autofix_handler and autofix_handler[diagnostic.code] then
          apply_code_action(action)
          return
        end
      end
    end
    default_code_action_handler(...)
  end
end

return M
