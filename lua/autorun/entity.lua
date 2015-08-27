
_E = {}
_E.__index = _E

function _E:_initialize()
	self:setPos( Vector( 0, 0 ) )
	self:generateBody( game.getWorld(), "static" )
	self:setHull( 5, 5 )
	self.__shouldDraw = true 
end

function _E:initialize()

end

function _E:getIndex()
	return self._index
end

function _E:draw()
	self:drawImage()
end

function _E:think()

end

function _E:touch()

end 

function _E:physicsCollide()

end 

function _E:setBodyType( type )
	self:getBody():setType( type )
end 

function _E:generateBody( world, type )
	local x,y = self:getNumPos()
	local body = love.physics.newBody( world, x, y, type )
	self:setBody( body )
end 

function _E:setBody( body )
	self.__body = body
end 

function _E:getBody()
	local fix = self:getFixture()
	if fix then
		return fix:getBody()
	else
		return self.__body 
	end
end 

function _E:getFixture()
	return self.__fixture 
end 

function _E:setFixture( fix )
	self.__fixture = fix 
end 

function _E:setGroupIndex( group )
	if self:getFixture() then
		self:getFixture():setGroupIndex( group )
	end
end 

function _E:setShape( shape, density )
	self.__shape = shape 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), density or 1 )
	self:setFixture( fix )
end 

function _E:newCircleShape( rad )
	local shape = love.physics.newCircleShape( rad )
	self:setShape( shape )
end 

function _E:newChainShape( ... )
	local shape = love.physics.newChainShape( unpack( ... ) )
	self:setShape( shape )
end 

function _E:newPolygonShape( ... )
	local shape = love.physics.newPolygonShape( unpack( ... ) )
	self:setShape( shape )
end

function _E:newRectangleShape( width, height )
	local shape = love.physics.newRectangleShape( width, height )
	self:setShape( shape )
end 

function _E:getShape()
	if not self:getFixture() then
		return self.__shape 
	else 
		return self:getFixture():getShape()
	end 
end 

function _E:setHull( width, height )
	self:newRectangleShape( width, height )
end 

function _E:getColor()
	return self.__Color
end 

function _E:setColor( clr )
	self.__Color = clr 
end

function _E:setAlpha( a )

end  

function _E:physicsinit()

end 

function _E:physWake()

end 

function _E:physSleep()

end

function _E:setImage( img )
	if type( img ) == "image" then 
		self.__image = img 
	else 
		self.__image = love.graphics.newImage( "sprites/"..img )
	end 
end 

function _E:getImage() 
	return self.__image
end 

function _E:drawImage()
	love.graphics.draw( self:GetImage() )
end

function _E:draw()
	self:DrawImage()
end

function _E:setNoDraw( bool )
	self.__shouldDraw = bool 
end 

function _E:shouldDraw()
	return self.__shouldDraw
end 

function _E:setPos( vec, y )
	if y then
		self.__pos = Vector( vec, y )
	else 
		self.__pos = vec 
	end
	local body = self:getBody()
	body:setPosition( self:getNumPos() )
end 

function _E:getPos()
	local body = self:getBody()
	if body then
		local x,y = body:getPosition()
		return Vector( x, y )
	else 
		return  self.__pos or Vector( 0, 0 )
	end
end 

function _E:getNumPos()
	local p = self:getPos()
	return p.x,p.y
end 