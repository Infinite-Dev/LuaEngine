
Vector = {}
Vector.__index = Vector

function Vector:GetNormal()
	local m = self:GetMagnitude()
	return Vector( self.x/m, self.x/m )
end

function Vector:Normalize()
	self = self:GetNormal()
end

function Vector:GetMagnitude()
	return math.sqrt( self.x^2 + self.y^2 )
end

function Vector:Length()
	return math.sqrt( self.x^2 + self.y^2 )
end

function Vector:SqrDist( vec )
	return ( self.x - vec.x )^2 + ( self.y - vec.y )^2
end

function Vector:Distance( vec )
	return math.sqrt( ( self.x - vec.x )^2 + ( self.y - vec.y )^2 )
end

function Vector:DotProduct( vec )
	return (self.x * vec.x + self.y * vec.y)
end

function Vector.new( x, y )
	return setmetatable( {x = x or 0, y = y or 0}, Vector )
end

local vMeta =
{
	__call = function(_, ...) return Vector.new(...) end,
	__mul = function( t, other )
		if type( other ) == "table" then 
			return Vector( t.x*other.x, t.x*other.y)
		else 
			return Vector( t.x*other, t.y*other )
		end
	end,
	__div = function( t, other )
		if type( other ) == "table" then 
			return Vector( t.x/other.x, t.x/other.y)
		else 
			return Vector( t.x/other, t.y/other )
		end
	end,
	__add = function( t, other )
		if type( other ) == "table" then 
			return Vector( t.x + other.x, t.x + other.y)
		else 
			return t 
		end
	end,
	__sub = function( t, other )
		if type( other ) == "table" then 
			return Vector( t.x - other.x, t.x - other.y)
		end
	end
}

setmetatable( Vector, vMeta )