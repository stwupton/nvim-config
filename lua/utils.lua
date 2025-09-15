local M = {}

-- @param value? string 
-- @return boolean
function M.is_empty(value)
	return value == nil or value.len == 0
end

return M
