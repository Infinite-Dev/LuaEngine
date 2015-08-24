--[[----------------------------------------
	string.EndsWith( string, end_string )
	Checks if a string ends with another string.
--]]----------------------------------------
function string.EndsWith( str, end_str )
	local len = string.len( str )
	local len2 = string.len( end_str )
	if string.sub( str, len - len2, len ) == end_str then
		return true
	end
return false
end
