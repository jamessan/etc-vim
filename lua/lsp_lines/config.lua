local M = {}

M.setup = function(options)
  local defaults = {
    box_drawing_characters = {
      vertical = "│",
      vertical_right = "├",
      horizontal_up = "┴",
      cross = "┼",
      up_right = "└",
      horizontal = "─",
    },
  }

  if options == nil then
    M.config = defaults
  else
    M.config = vim.tbl_deep_extend("keep", options, defaults)
  end
end

return M
