--[[--------------------------------------------------------------------------------
	string.endsWith( string, end_string )
	Checks if a string ends with another specified string array.
--]]--------------------------------------------------------------------------------
function string.endsWith( str, end_str )
	local len = string.len( str )
	local len2 = string.len( end_str )
	if string.sub( str, len - len2, len ) == end_str then
		return true
	end
return false
end

--[[--------------------------------------------------------------------------------
	string.explode( string string, string explode character, bool split escapes )
	Turns a string into a table. Explode Character determines what characters
	the string you should be split up on (i.e. " " would make it split into each
	word sperated by a space).
--]]--------------------------------------------------------------------------------
function string.explode( s, xchar )
	local tbl = {}
	local j = 0
	local len = xchar and #xchar or 0 
	for i = 1,#s do 
		if not xchar or xchar == "" then 
			tbl[ #tbl+1 ] = string.sub( s, i, i )
		else
			local icheck = i + len - 1 
			local comp = string.sub( s, i, icheck )
			if comp == xchar then 
				tbl[ #tbl+1 ] = string.sub( s, j, icheck-1 )
				i = i + len - 1
				j = i + 1
			elseif i == #s then 
				tbl[ #tbl+1 ] = string.sub( s, j, #s )
			end 
		end 
	end 
	return tbl 
end 

function string.implode( tbl, impstring )
	local str = ""
	for i = 1,#tbl do 
		str = str..impstring..tbl[ i ]
	end 
	return str 
end 
