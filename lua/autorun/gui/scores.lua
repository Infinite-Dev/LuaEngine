
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

local titleFont = lg.newFont( 30 )

local textBorder = 20
local border = 15
local hText = "HIGHSCORES"
function PANEL:initialize()

	local w, h = love.graphics.getDimensions()
	self:setSize( w, h )

	local prnt = self:getParent()

	local sz = 40
	local csz = sz*0.8
	local pad = 10
	local b = gui.create( "button", self )
	b:setPos( pad, pad )
	b:setSize( sz, sz )
	b:setText( "<" )
	b:setTextColor( 255, 255, 255, 255 )
	function b:paint( w, h )
		lg.setColor( 255, 255, 255, 220 )
		love.graphics.circle( "line", w/2, w/2, csz/2, 100 )
	end
	function b:doClick()
		prnt:moveTo( 0, 0, 0.7, 0.5, 0.5 )
	end

	local b = 6
	local fw,fh = titleFont:getWidth( hText ),titleFont:getHeight( hText )
	local panel = gui.create( "panel", self )
	panel:setSize( w - border*2, h - fh - textBorder - border*2 )
	panel:setPos( border, fh + textBorder + border )
	function panel:paint( w, h )
		lg.setColor( 22, 22, 22, 255 )
		lg.rectangle( "fill", 0, 0, w, h )

		lg.setColor( 3, 3, 3, 255 )
		lg.rectangle( "fill", b, b, w - b*2, h - b*2 )
	end

end

function PANEL:paint( w, h )

	lg.setColor( 11, 11, 11, 120 )
	lg.rectangle( "fill", 0, 0, w, h )

	lg.setColor( 255, 255, 255, 230 )
	lg.setFont( titleFont )
	local fW,fH = titleFont:getWidth( hText ),titleFont:getHeight( hText )
	lg.print( hText, w/2 - fW/2 , textBorder )

end
gui.register( "scores", PANEL, "base" )
