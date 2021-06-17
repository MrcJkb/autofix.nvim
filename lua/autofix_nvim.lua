local diagnostic = require'autofix_nvim.diagnostic'
local lsp = vim.lsp

local M = {}


-- Runs LSP diagnostic autofix operations on the current buffer.
-- TODO placeholder
local function run_lsp_diagnostic_autofix_current_buf()
  local diagnostics = diagnostic.current_buf_get_diagnostics()
  print(vim.inspect(diagnostics))
end

function M.remove_unused_imports()
  local diagnostics = diagnostic.current_buf_get_diagnostics()
  print(vim.inspect(diagnostics))
end

return M
