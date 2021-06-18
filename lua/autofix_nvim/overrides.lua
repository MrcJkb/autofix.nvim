local lsp_handlers = vim.lsp.handlers
local decorators = require'autofix_nvim.decorators'
local diagnostic_util = require'autofix_nvim.diagnostic'

local M = {}

-- Wraps the default diagnostics handler and executes an autofix handler if one is found
local function override_diagnostics_handler()
  local default_diagnostics_handler = lsp_handlers['textDocument/publishDiagnostics']
  lsp_handlers['textDocument/publishDiagnostics'] = function(...)
    local params = select(3, ...)
    print(vim.inspect(params))
    local autofix_handler = diagnostic_util.find_autofix_handler(params.diagnostics)
    if autofix_handler then
      autofix_handler()
    else
      default_diagnostics_handler(...)
    end
  end
end

local function override_code_action_handler()
  lsp_handlers['textDocument/codeAction'] = decorators.get_autofix_code_action_handler()
end

function M.setup()
  override_diagnostics_handler()
  override_code_action_handler()
end

return M
