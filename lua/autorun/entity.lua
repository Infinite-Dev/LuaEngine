
_E = {}
_E.__index = _E

function _E:_initialize()
	self:setPos( Vector( 0, 0 ) )
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
	return self.__body 
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

function _E:setShape( shape )
	self.__shape = shape 
end 

function _E:getShape()
	return self.__shape 
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
	local p 
	if y then 
		p = { x = vec, y = y }
	else 
		p = { x = vec.x, y = vec.y }
	end
	local body = self:getBody()
	if body then
		body:setPosition( p.x, p.y )
	else 
		self.__pos = p 
	end 
end 

function _E:getPos()
	local body = self:getBody()
	if body then
		local x,y = body:getPosition()
		return x, y
	else 
		return  self.__pos.x, self.__pos.y 
	end
end 

function _E:remove()
	self = nil 
end 