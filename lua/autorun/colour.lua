
Color = {}
Color.__index = Color

function Color.new( r, g, b, a )
	return setmetatable( { r = r, g = g, b = b, a = a or 255 }, Color )
end

local cMeta =
{
	__call = function(_, ...) return Color.new(...) end,
	__tostring = function( ) return "clrrrrwadawd" end 
}

setmetatable( Color, cMeta )
