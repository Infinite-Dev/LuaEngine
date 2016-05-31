
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

	self.displayPanel = gui.create( "panel", self )
	self.displayPanel:setSize( self:getSize() )
	self.displayPanel.paint = function() end
	self.displayPanel:setRestrictChildClick( true )

	self.scroll = gui.create( "vertScrollbar", self )

	self.initialized = true
end

function PANEL:vertScrollbarIsEnabled()
	return self.__vertScroll
end

function PANEL:enableVertScrollbar( b )

	if b then

		local scrollw =  math.min( self:getWidth()*0.037, 40 )
		self.scroll:setSize( scrollw, self:getHeight() )
		self.scroll:setPos( self:getWidth() - scrollw, 0 )

		local w, h = self:getSize()
		self.displayPanel:setSize( w - scrollw, h )

	elseif self.scroll then

		self.scroll:setVisible( false )

	end

	self.__vertScroll = b

end

function PANEL:onWheelMoved( delta )
	if self.scroll then
		self.scroll:onWheelMoved( delta )
	end
end

function PANEL:onSizeChanged()
	local b = self:vertScrollbarIsEnabled()
	if b then
		local scrollw =  math.min( self:getWidth()*0.037, 40 )
		self.scroll:setSize( scrollw, self:getHeight() )
		self.scroll:setPos( self:getWidth() - scrollw, 0 )

		local w, h = self:getSize()
		self.displayPanel:setSize( w - scrollw, h )
	end
end

function PANEL:onChildAdded( pnl )
	if self.initialized then
		pnl:setParent( self.displayPanel )
	end
end

function PANEL:onDeltaSet( d )

 	local children = self.displayPanel:getChildren()
	local highY = self:getY() + self:getHeight()
	local targ = false
	for k,v in pairs( children ) do
		local targY = ( v.originY or v:getY() ) + v:getHeight()
		if targY > highY then
			highY = targY
			targ = v
		end
	end

	if targ then
		local panelMaxY = self:getY() + self:getHeight()
		local dif = highY - panelMaxY
		local v = self.displayPanel
		if not v.originY then
			local x,y = v:getLocalPos()
			v.localOriginY = y
			v.originY = v:getY()
		end
		local x,y = v:getLocalPos()
		v:setPos( x, v.localOriginY - dif*d )
	end

end

function PANEL:paint()
	lg.setColor( 44, 44, 44, 255 )
	lg.rectangle( "fill", 0, 0, self:getWidth(), self:getHeight() )
end
gui.register( "scrollPanel", PANEL, "base" )
