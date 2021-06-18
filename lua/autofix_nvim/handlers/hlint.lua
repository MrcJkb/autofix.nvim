local lsp_util = vim.lsp.util
local M = {}

-- Handler for the Use fewer imports diagnostic
-- @param range table LSP range from the diagnostic
M['refact:Use fewer imports'] = function(range)
  -- TODO refactor
  -- FIXME Use decorator to pass handler instead of overriding (currenly causes import loop)
  -- FIXME range does not seem to work here
  print(vim.inspect(range))
  local range_params = {
    context = {},
    textDocument = lsp_util.make_text_document_params(),
    range = range,
  }
  print(vim.inspect(range_params)) -- XXX
  vim.lsp.buf_request(0, 'textDocument/codeAction', range_params)
end

return M
