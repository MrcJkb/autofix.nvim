local lsp = vim.lsp
local autofix_handlers = require('autofix_nvim.handlers')
local M = {}

function M.current_buf_get_diagnostics()
  local current_bufnr = vim.api.nvim_get_current_buf()
  return lsp.diagnostic.get(current_bufnr, nil) or {}
end

-- Gets an autofix handler 
-- @param diagnostic table The diagnostic to get the autofix handler for
-- @return function|nil The autofix handler, which takes a diagnostic's range as a parameter
function M.get_autofix_handler(diagnostic)
  return diagnostic.source and autofix_handlers[diagnostic.source] or nil
end

-- Searches a list of diagnostics for an autofix handler
-- @param diagnostics Table the diagnostics to search
-- @return funcion|nil The first autofix handler that is found
function M.find_autofix_handler(diagnostics)
    for _, diagnostic in ipairs(diagnostics) do
        local autofix_handler = M.get_autofix_handler(diagnostic)
        if autofix_handler and autofix_handler[diagnostic.code] then
          return function() 
            autofix_handler[diagnostic.code](diagnostic.range)
          end
        end
    end
end

return M
