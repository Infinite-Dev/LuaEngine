
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
end

function PANEL:vertScrollbarIsEnabled()
	return self.__vertScroll
end

function PANEL:enableVertScrollbar( b )

	if b then

		self.scroll = gui.create( "vertScrollbar", self )

		local w =  self:getWidth()*0.03
		self.scroll:setSize( w, self:getHeight() )
		self.scroll:setPos( self:getWidth() - w, 0 )

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

function PANEL:paint()
	lg.setColor( 44, 44, 44, 255 )
	lg.rectangle( "fill", 0, 0, self:getWidth(), self:getHeight() )
end
gui.register( "scrollPanel", PANEL, "base" )
