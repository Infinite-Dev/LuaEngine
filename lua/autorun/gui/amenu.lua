
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

local buttonD =
{
	{ "Start Game", function( self )
		self:getParent():remove()
		game.changeState( "game" )
	end },
	{ "Options", function( self )
		local prnt = self:getParent()
		local w,h = prnt:getSize()
		if not self.options then
			self.options = gui.create( "options", prnt )
			self.options:setPos( -w, 0 )
		end
		prnt:moveTo( w, 0, 0.7, 0.5, 0.5 )
	end },
	{ "Highscores", function( self )
		local prnt = self:getParent()
		local w,h = prnt:getSize()
		if not self.scores then
			self.scores = gui.create( "scores", prnt )
			self.scores:setPos( w, 0 )
		end
		prnt:moveTo( -w, 0, 0.7, 0.5, 0.5 )
	end },
	{ "Quit", function( self )
		local w,h = self:getParent():getSize()
		local qConfirm = gui.create( "ynBox" )
		qConfirm:setText( "Are you sure?" )
		qConfirm:setSize( w/4, h/5 )
		qConfirm:center()
		qConfirm:doModal( true )
		function qConfirm:yesFunc()
			love.event.quit( )
		end
		function qConfirm:noFunc()
			qConfirm:remove()
		end
	end }
}

local padding = 40
function PANEL:initialize()

	self:setClampDrawing( false )
	self.buttons = {}
	local w, h = love.graphics.getDimensions()
	self:setSize( w, h )
	self:center()

	local bWidth = w/5
	local bHeight = h/10
	local UISpace = h-padding*2
	local gap = UISpace/#buttonD
	for i = 1,#buttonD do

		local tbl = buttonD[ i ]
		local b = gui.create( "button", self )
		local bY = gap*(i-1) + bHeight/2 -- fuk dis gey erth
		b:setSize( bWidth, bHeight )
		b:setPos( w/2 - bWidth/2, bY + padding )
		b:setText( tbl[ 1 ] )
		b.clr = 120
		b.alpha = 150
		b.tAlpha = 150
		b.circles = {}
		b:setClampDrawing( true )

		function b:addCircle( x, y, t, s, clrTable )
			x = x - self:getX()
			y = y - self:getY()
			local loveTime = love.timer.getTime()
			local data = { x = x, y = y, dur = t, start = loveTime, size = s, clr = clrTable, alpha = clrTable[ 4 ] }
			table.insert( self.circles, data )
		end

		function b:doClick()
			tbl[ 2 ]( self )
			local x, y = love.mouse.getPosition()
			self:addCircle( x, y, 0.5, 80, { 255, 255, 255, 255 } )
		end

		function b:paint( w, h )

			love.graphics.setColor( 33, 33, 33, 255 )
			draw.roundedRect( 0, 0, w, h, 20 )

			local function stencilFunc()
				draw.roundedRect( 0, 0, w, h, 20 )
			end

			love.graphics.stencil( stencilFunc, "replace", 1 )

			love.graphics.setStencilTest( "greater", 0 )

				for i = 1,#self.circles do
					local c = self.circles[ i ]
					local t = love.timer.getTime()
					local p = ( t - c.start )/c.dur
					c.clr[ 4 ] = c.alpha*( 1 - p )
					love.graphics.setColor( unpack( c.clr ) )
					love.graphics.circle( "fill", c.x, c.y, c.size*p, 40 )
				end

			love.graphics.setStencilTest()

		end

		function b:onCursorEntered()
			local x, y = love.mouse.getPosition()
			self:addCircle( x, y, 1.35, 150, { 255, 255, 255, 150 } )
			self.tAlpha = 255
		end

		function b:onCursorExited()
			self.tAlpha = 150
		end

		function b:think()

			if self.alpha ~= self.tAlpha then
				self.alpha = math.approach( self.alpha, self.tAlpha, 8 )
				b:setTextColor( { self.clr, self.clr, self.clr, self.alpha } )
			end
			for i,c in pairs( self.circles ) do
				local t = love.timer.getTime()
				if c.start + c.dur < t then
					table.remove( self.circles, i )
				end
			end

		end

		b:setTextColor( { b.clr, b.clr, b.clr, b.alpha } )
	end

end

function PANEL:paint( w, h )

	lg.setColor( 11, 11, 11, 120 )
	lg.rectangle( "fill", 0, 0, w, h )

end
gui.register( "aMenu", PANEL, "panel" )
