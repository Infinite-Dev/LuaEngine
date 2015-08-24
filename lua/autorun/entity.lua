
_E = {}
_E.__index = _E

function _E:Initialize()

end

function _E:GetIndex()
	return self.__Index
end

function _E:Draw()
	self:DrawImage()
end

function _E:Think()

end

function _E:Touch()

end 

function _E:PhysicsCollide()

end 

function _E:SetHull( vec, vec2 )
	self.__Mins = vec 
	self.__Max = vec2 
end 

function _E:GetColor()
	return self.__Color
end 

function _E:SetColor( clr )
	self.__Color = clr 
end

function _E:SetAlpha( a )

end  

function _E:PhysicsInit()

end 

function _E:PhysWake()

end 

function _E:PhysSleep()

end

function _E:SetImage( img )
	if type( img ) == "image" then 
		self.__Image = img 
	else 
		self.__Image = love.graphics.newImage( "sprites/"..img )
	end 
end 

function _E:GetImage() 
	return self.__Image
end 

function _E:DrawImage()
	love.graphics.draw( self:GetImage() )
end

function _E:Draw()
	self:DrawImage()
end

function _E:SetNoDraw( bool )
	self.__shouldDraw = bool 
end 

function _E:ShouldDraw()
	return self.__shouldDraw
end 

function _E:SetPos( vec )
	self.__pos = vec 
end 

function _E:GetPos()
	return self.__pos or Vector( 0, 0 )
end 