

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

function PANEL:_Initialize()
end

function PANEL:Init()
end

function PANEL:SetClampDrawing( bool )
	self.__clampDrawing = bool
end

function PANEL:SetParent( pnl )
	local parent = self:GetParent()
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

function PANEL:GetParent()
	if self.__parent ~= nil and self.__parent > 0 then
		return gui.Objects[ self.__parent ]
	end
	return false
end

function PANEL:IsChild()
	if type( self:GetParent() ) == "table" then
		return true
	end
return false
end

function PANEL:IsParent()
	return #self.__children > 0
end	

function PANEL:SetSize( w, h )
	self.__w = w
	self.__h = h
	self:OnSizeChanged()
end

function PANEL:OnSizeChanged()
end

function PANEL:Center()
	if self:IsChild() then
	
		local parent = self:GetParent()
		local x,y = parent:GetPos()
		local w,h = parent:GetSize()
		local w2,h2 = self:GetSize()
		
		self:SetPos( w/2 - w2/2 , h/2 - h2/2 )
		
		self.__centred = true
		
	else
		local x,y = lg.getWidth()/2 - self:GetWide()/2, lg.getHeight()/2 - self:GetTall()/2
		self:SetPos( x, y )
		self.__centred = true
	end
end

function PANEL:GetSize()
	return (self.__w),(self.__h)
end

function PANEL:GetTall()
	return self.__h
end

function PANEL:GetWide()
	return self.__w
end

function PANEL:SetPos( x, y )
	if type( x ) == "table" then 
		y = x.y
		x = x.x  
	end 
	local x = math.floor( x )
	local y = math.floor( y )
	local oldx,oldy = self:GetPos()
	if self:IsChild() then
		local prnt = self:GetParent()
		local _x,_y = prnt:GetPos()
		self.__x = x + _x
		self.__y = y + _y
	else
		self.__x = x
		self.__y = y
	end
	
	if self:IsParent() then
		for i = 1,#self.__children do
			local child = self.__children[ i ]
			local _x,_y = child:GetPos()
			local x_add = _x - oldx 
			local y_add = _y - oldy
			child.__x = x + x_add
			child.__y = y + y_add
		end
	end
	self.centred = false
end

function PANEL:GetPos()
	return self.__x,self.__y
end

function PANEL:GetX()
	return self.__x
end

function PANEL:GetY()
	return self.__y
end

function PANEL:Paint( w, h )
	lg.setColor( 88, 88, 88, 255 )
	lg.rectangle( "fill", 0, 0, w, h )
end

function PANEL:IsHovered()
	return self.__Hovered
end

function PANEL:PaintOver( w, h )
end

function PANEL:Think()
end

function PANEL:OnCursorEntered()
end	

function PANEL:OnCursorExited()
end

function PANEL:CanClick()
	return self.__CanClick
end

function PANEL:__Click()

end

local in_area = util.IsInArea
function PANEL:__MouseThink()
	local x,y = lm.getPosition()
	if self.__Hovered == false and in_area( x, y, self.__x, self.__y, self:GetSize() ) then
		self.__Hovered = true
		self:OnCursorEntered()
	elseif self.__Hovered == true and not in_area( x, y, self.__x, self.__y, self:GetSize() ) then
		self.__Hovered = false
		self:OnCursorExited()
	end
end

function PANEL:moveTo( x, y, time, ease )
	local pX,pY = self:GetPos()
	local dist = math.distance( pX, pY, x, y )
	local vec = Vector( x, y )
	local vec2 = Vector( pX, pY )
	local norm = (vec-vec2):normalized()
	local add = (norm*dist)
	local t = love.timer.getTime()
	local tEnd = t + time 
	local hname = "MoveHook"..tostring( self )
	hook.Add( "Think", hname, function()
		if self then 
			local p = (love.timer.getTime()-t)/(time)
			self:SetPos( (vec2 + add*p) ) 
			if p >= 1 then 
				hook.Remove( "Think", hname )
			end 
		else 
			hook.Remove( "Think", hname )
		end  
	end ) 
end 

function PANEL:Remove()
	local parent = self:GetParent()
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
		child:Remove()
	end
	gui.Objects[ self.__id ] = nil
end

gui.Register( "Base", PANEL )