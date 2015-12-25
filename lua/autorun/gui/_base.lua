

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
	self.__parent = pnl
	pnl.__children[ #pnl.__children + 1] = self
end

function PANEL:getParent()
	return self.__parent or false 
end

function PANEL:isChild()
	if type( self:getParent() ) == "table" then
		return true
	end
return false
end

function PANEL:isParent()
	return #self:getChildren() > 0
end	

function PANEL:getChildren()
	return self.__children
end 

function PANEL:isChildOf( pnl )
	if pnl then 
		local c = pnl:getChildren()
		for i = 1,#c do 
			if c[ i ] == self then 
				return true 
			end 
		end 
	end
	return false 
end 

function PANEL:isParentOf( pnl )
	if pnl then 
		local p = pnl:getParent()
		if p == self then 
			return true 
		end 
	end
	return false  
end 

function PANEL:setSize( w, h )
	self.__w = w
	self.__h = h
	self:onSizeChanged( w, h )
end

function PANEL:onSizeChanged( w, h )
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
		local x,y = lg.getWidth()/2 - self:getWidth()/2, lg.getHeight()/2 - self:getHeight()/2
		self:setPos( x, y )
		self.__centred = true
	end
end

function PANEL:getSize()
	return (self.__w),(self.__h)
end

function PANEL:getHeight()
	return self.__h
end

function PANEL:getWidth()
	return self.__w
end

function PANEL:setPos( x, y )
	if type( x ) == "table" then 
		y = x.y
		x = x.x  
	end 
	local oldX,oldY = self:getPos()
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
		local cTbl = self:getChildren()
		for i = 1,#cTbl do
			local child = cTbl[ i ]
			local cX,cY = child:getPos()
			child:setPos( cX - oldX  , cY - oldY )
		end
	end
	gui.generateDrawOrder()
	self.centred = false
end

function PANEL:getPos()
	return self.__x,self.__y
end

function PANEL:getLocalPos()
	if self:isChild() then 
		local x,y = self:getParent():getPos()
		return self.__x - x,self.__y - y 
	else 
		return self.__x,self.__y
	end 
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

function PANEL:getID()
	return self.__id 
end

function PANEL:setZ( num, b )
	self.__z = num
	if num > gui.getMaxZ() then 
		gui.setMaxZ( num )
	elseif num < gui.getMinZ() then 
		gui.setMinZ( num )
	end 
	if self:isParent() then
		local c = self:getChildren()
		for i = 1,#c do 
			c[ i ]:setZ( num + 1 )
		end 
	end 
	gui.generateDrawOrder()
end 

function PANEL:getZ()
	return self.__z 
end 

function PANEL:bringToFront()
	local z =gui.getMaxZ()+1
	self:setZ( z )
end 

function PANEL:sendToBack()
	self:setZ( gui.getMinZ() - 1 )
end 

function PANEL:getClass()
	return self.__class
end 

function PANEL:moveTo( x, y, time, easein, easeout, callback, ... )
	local pX,pY = self:getPos()
	local dist = math.distance( pX, pY, x, y )
	local vec = Vector( x, y )
	local vec2 = Vector( pX, pY )
	local norm = (vec-vec2):normalized()
	local add = (norm*dist)
	local t = love.timer.getTime()
	local tEnd = t + time 
	local hname = "MoveHook"..tostring( self )
	local delay = 0.01
	local thinkTime = t 
	hook.add( "think", hname, function()
		if self then 
			local t2 = love.timer.getTime()
			if t2 > thinkTime then  
				local p = (t2-t)/(time)
				local drawP = math.easeInOut( p, easein, easeout )
				self:setPos( (vec2 + add*drawP) ) 
				if p >= 1 then 
					self:setPos( x, y )
					hook.remove( "think", hname )
					if callback then 
						callback( self, unpack( args ) )
					end
				end 
				thinkTime = t2 + delay 
			end 
		else 
			hook.remove( "think", hname )
		end  
	end ) 
end 

function PANEL:doModal( b )
	if b then
		gui.setModal( self )
	elseif gui.getModal == self then 
	    gui.setModal()
	end
	gui.generateDrawOrder()
end

function PANEL:isModal()
	return gui.getModal() == self 
end 

function PANEL:blurBackground( b, fadetime )
	if b then 
		local startTime = love.timer.getTime()
		local time = startTime + (fadetime or 0)
		local endAlpha = 200
		self.__backblur = b 
		self.__blurpnl = gui.create( "panel" )
		local p = self.__blurpnl 

		local scrw, scrh = lg.getDimensions()
		p:setSize( scrw, scrh )
		p:sendToBack()
		function p:paint( w, h )
			local p = math.min( (love.timer.getTime()-startTime)/(time-startTime), 1 )
			lg.setColor( 0, 0, 0, p*endAlpha )
			lg.rectangle( "fill", 0, 0, scrw, scrh )
		end
	else 
		if self.__blurpnl then 
			self.__blurpnl:remove()
		end 
		self.__backblur = false 
	end 
	gui.generateDrawOrder()
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

	for k, child in pairs(self:getChildren()) do
		child:remove()
	end

	if self.__backblur then 
		self.__blurpnl:remove()
	end 

	if self:isModal() then 
		gui.setModal( nil )
	end 
	gui.objects[ self.__id ] = nil
	gui.generateDrawOrder()

end

gui.register( "base", PANEL )