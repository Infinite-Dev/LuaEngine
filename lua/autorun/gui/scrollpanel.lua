
--[[--
 ▄▀▀█▄▄   ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀▄ ▀▀▄  ▄▀▀▄ ▀▄  ▄▀▄▄▄▄
█ ▄▀   █ ▐  ▄▀   ▐ █ █   ▐ █   ▀▄ ▄▀ █  █ █ █ █ █    ▌
▐ █    █   █▄▄▄▄▄     ▀▄   ▐     █   ▐  █  ▀█ ▐ █
  █    █   █    ▌  ▀▄   █        █     █   █    █
 ▄▀▄▄▄▄▀  ▄▀▄▄▄▄    █▀▀▀       ▄▀    ▄▀   █    ▄▀▄▄▄▄▀
█     ▐   █    ▐    ▐          █     █    ▐   █     ▐
▐         ▐                    ▐     ▐        ▐
--]]--

local lg = love.graphics
local lm = love.mouse
local PANEL = {}

function PANEL:_initialize()
	self.__vertScroll = false
	self:setClampDrawing( true )
end

function PANEL:vertScrollbarIsEnabled()
	return self.__vertScroll
end

function PANEL:enableVertScrollbar( b )

	if b then

		self.scroll = gui.create( "vertScrollbar", self )

		local w =  self:getWidth()*0.037
		self.scroll:setSize( w, self:getHeight() )
		self.scroll:setPos( self:getWidth() - w*2, 0 )

		self:setSize( self:getWidth() - w, self:getHeight() )

	elseif self.scroll then

		self.scroll:setVisible( false )
		self:setSize( self:getWidth() + self.scroll:getWidth(), self:getHeight() )

	end

	self.__vertScroll = b

end

function PANEL:onWheelMoved( delta )
	if self.scroll then
		self.scroll:onWheelMoved( delta )
	end
end

function PANEL:onSizeChanged()
end

function PANEL:onChildAdded( pnl )
end

function PANEL:onDeltaSet( d )

 	local children = self:getChildren()
	local highY = self:getY() + self:getHeight()
	local targ = nil
	for k,v in pairs( children ) do
		if v ~= self.scroll then
			local targY = ( v.originY or v:getY() ) + v:getHeight()
			if targY > highY then
				highY = targY
				targ = v
			end
		end
	end

	if targ then

		local panelMaxY = self:getY() + self:getHeight()
		local dif = highY - panelMaxY
		for k,v in pairs( children ) do
			if v ~= self.scroll then
				if not v.originY then
					local x,y = v:getLocalPos()
					v.localOriginY = y
					v.originY = v:getY()
				end
				local x,y = v:getLocalPos()
				v:setPos( x, v.localOriginY - dif*d )
			end
		end

	end

end

function PANEL:paint()
	lg.setColor( 44, 44, 44, 255 )
	lg.rectangle( "fill", 0, 0, self:getWidth(), self:getHeight() )
end
gui.register( "scrollPanel", PANEL, "base" )
