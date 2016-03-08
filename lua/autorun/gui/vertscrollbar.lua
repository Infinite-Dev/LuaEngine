
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

function PANEL:init()

	self.up = gui.create( "button", self )
	self.up:setText( "/\\" )
	self.up:setTextColor( 255, 255, 255, 255 )
	function self.up.paint( up, w, h )
		lg.setColor( 0, 102, 255, 255 )
		lg.rectangle( "fill", 0, 0, w, h )
	end
	function self.up.doClick( up )
		self.scroll:setDelta( self.scroll:getDelta() - 0.05 )
	end

	self.down = gui.create( "button", self )
	self.down:setText( "\\/" )
	self.down:setTextColor( 255, 255, 255, 255 )
	function self.down.paint( down, w, h )
		lg.setColor( 0, 102, 255, 255 )
		lg.rectangle( "fill", 0, 0, w, h )
	end
	function self.down.doClick( down )
		self.scroll:setDelta( self.scroll:getDelta() + 0.05 )
	end

	self.scroll = gui.create( "button", self )
	self.scroll.offsetY = 0
	self.scroll:setText( "" )
	function self.scroll.setDelta( scroll, d )
		d = math.min( d, 1 )
		d = math.max( 0, d )
		local minY = self.up:getY() + self.up:getHeight()
		local maxY = self.down:getY() - scroll:getHeight()
		local y = (maxY-minY)*d + minY
		scroll:setPos( 0, y )
		scroll.delta = d
	end
	self.scroll:setDelta( 0 )

	function self.scroll.getDelta( scroll )
		return scroll.delta
	end

	function self.scroll.doClick( scroll )
		scroll.dragging = true
		scroll.offsetY = love.mouse.getY() - scroll:getY()
	end

	function self.scroll.onReleased( scroll, button )
		scroll.dragging = false
		scroll.offsetY = 0
	end

	function self.scroll.isDragging( scroll )
		return scroll.dragging
	end

	function self.scroll.think( scroll )
		if scroll:isDragging() then
			local minY = self.up:getY() + self.up:getHeight()
			local maxY = self.down:getY() - scroll:getHeight()
			local y = love.mouse.getY()
			y = math.clamp( minY, maxY )
		end
	end

end

function PANEL:onWheelMoved( delta )
	self.scroll:setDelta( self.scroll:getDelta() + delta*-0.01 )
end

function PANEL:onSizeChanged()

	local h = self:getHeight()*0.05

	self.up:setPos( 0, 0 )
	self.up:setSize( self:getWidth(), h )

	self.down:setPos( 0, self:getHeight() - h )
	self.down:setSize( self:getWidth(), h )

	self.scroll:setSize( self:getWidth(), 150 )
	self.scroll:setDelta( self.scroll:getDelta() )

end

function PANEL:paint()

	lg.setColor( 22, 22, 22, 255 )
	lg.rectangle( "fill", 0, 0, self:getWidth(), self:getHeight() )

	lg.setColor( 44, 44, 44, 255 )
	lg.rectangle( "line", 0, 0, self:getWidth(), self:getHeight() )

end
gui.register( "vertScrollbar", PANEL, "base" )
