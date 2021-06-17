local lsp = vim.lsp
local M = {}

function M.current_buf_get_diagnostics()
  local current_bufnr = vim.api.nvim_get_current_buf()
  return lsp.diagnostic.get(current_bufnr, nil) or {}
end

return M
