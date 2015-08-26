
_E = {}
_E.__index = _E

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

function _E:setHull( vec, vec2 )
	self.__Mins = vec 
	self.__Max = vec2 
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

function _E:setPos( vec )
	self.__pos = vec 
end 

function _E:getPos()
	return self.__pos or Vector( 0, 0 )
end 