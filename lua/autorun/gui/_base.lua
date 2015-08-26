

--[[

 ▄▀▀█▄▄   ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀▄ ▀▀▄  ▄▀▀▄ ▀▄  ▄▀▄▄▄▄  
█ ▄▀   █ ▐  ▄▀   ▐ █ █   ▐ █   ▀▄ ▄▀ █  █ █ █ █ █    ▌ 
▐ █    █   █▄▄▄▄▄     ▀▄   ▐     █   ▐  █  ▀█ ▐ █      
  █    █   █    ▌  ▀▄   █        █     █   █    █      
 ▄▀▄▄▄▄▀  ▄▀▄▄▄▄    █▀▀▀       ▄▀    ▄▀   █    ▄▀▄▄▄▄▀ 
█     ▐   █    ▐    ▐          █     █    ▐   █     ▐  
▐         ▐                    ▐     ▐        ▐   

]]

local lg = love.graphics
local lm = love.mouse
 
local PANEL = {}

function PANEL:_initialize()
end

function PANEL:init()
end

function PANEL:setClampDrawing( bool )
	self.__clampDrawing = bool
end

function PANEL:setParent( pnl )
	local parent = self:getParent()
	if parent then
		local new_children = {}
		for k,v in pairs( parent.__children ) do
			if v ~= self then
				new_children[ k ] = v
			end
		end
		parent.__children = new_children
	end
	self.__parent = pnl.__id
	pnl.__children[ #pnl.__children + 1] = self
end

function PANEL:getParent()
	if self.__parent ~= nil and self.__parent > 0 then
		return gui.objects[ self.__parent ]
	end
	return false
end

function PANEL:isChild()
	if type( self:getParent() ) == "table" then
		return true
	end
return false
end

function PANEL:isParent()
	return #self.__children > 0
end	

function PANEL:setSize( w, h )
	self.__w = w
	self.__h = h
	self:onSizeChanged()
end

function PANEL:onSizeChanged()
end

function PANEL:center()
	if self:isChild() then
	
		local parent = self:getParent()
		local x,y = parent:getPos()
		local w,h = parent:getSize()
		local w2,h2 = self:getSize()
		
		self:setPos( w/2 - w2/2 , h/2 - h2/2 )
		
		self.__centred = true
		
	else
		local x,y = lg.getWidth()/2 - self:getWide()/2, lg.getHeight()/2 - self:getTall()/2
		self:setPos( x, y )
		self.__centred = true
	end
end

function PANEL:getSize()
	return (self.__w),(self.__h)
end

function PANEL:getTall()
	return self.__h
end

function PANEL:getWide()
	return self.__w
end

function PANEL:setPos( x, y )
	if type( x ) == "table" then 
		y = x.y
		x = x.x  
	end 
	local x = math.floor( x )
	local y = math.floor( y )
	local oldx,oldy = self:getPos()
	if self:isChild() then
		local prnt = self:getParent()
		local _x,_y = prnt:getPos()
		self.__x = x + _x
		self.__y = y + _y
	else
		self.__x = x
		self.__y = y
	end
	
	if self:isParent() then
		for i = 1,#self.__children do
			local child = self.__children[ i ]
			local _x,_y = child:getPos()
			local x_add = _x - oldx 
			local y_add = _y - oldy
			child.__x = x + x_add
			child.__y = y + y_add
		end
	end
	self.centred = false
end

function PANEL:getPos()
	return self.__x,self.__y
end

function PANEL:getX()
	return self.__x
end

function PANEL:getY()
	return self.__y
end

function PANEL:paint( w, h )
	lg.setColor( 88, 88, 88, 255 )
	lg.rectangle( "fill", 0, 0, w, h )
end

function PANEL:isHovered()
	return self.__hovered
end

function PANEL:paintOver( w, h )
end

function PANEL:think()
end

function PANEL:onCursorEntered()
end	

function PANEL:onCursorExited()
end

function PANEL:canClick()
	return self.__canClick
end

function PANEL:__click()

end

local in_area = util.isInArea
function PANEL:__mouseThink()
	local x,y = lm.getPosition()
	if self.__hovered == false and in_area( x, y, self.__x, self.__y, self:getSize() ) then
		self.__hovered = true
		self:onCursorEntered()
	elseif self.__hovered == true and not in_area( x, y, self.__x, self.__y, self:getSize() ) then
		self.__hovered = false
		self:onCursorExited()
	end
end

function PANEL:moveTo( x, y, time, ease )
	local pX,pY = self:getPos()
	local dist = math.distance( pX, pY, x, y )
	local vec = Vector( x, y )
	local vec2 = Vector( pX, pY )
	local norm = (vec-vec2):normalized()
	local add = (norm*dist)
	local t = love.timer.getTime()
	local tEnd = t + time 
	local hname = "MoveHook"..tostring( self )
	hook.add( "Think", hname, function()
		if self then 
			local p = (love.timer.getTime()-t)/(time)
			self:setPos( (vec2 + add*p) ) 
			if p >= 1 then 
				self:setPos( x, y )
				hook.remove( "Think", hname )
			end 
		else 
			hook.remove( "Think", hname )
		end  
	end ) 
end 

function PANEL:remove()
	local parent = self:getParent()
	if parent then
		local new_children = {}
		for k,v in pairs( parent.__children ) do
			if v.__id ~= self.__id then
				new_children[ k ] = v
			end
		end
		parent.__children = new_children
	end
	for k, child in pairs(self.__children) do
		child:remove()
	end
	gui.objects[ self.__id ] = nil
end

gui.register( "base", PANEL )