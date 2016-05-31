
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
local hText = "OPTIONS"
function PANEL:initialize()
	local w, h = love.graphics.getDimensions()
	self:setSize( w, h )

	local prnt = self:getParent()

	local sz = 40
	local csz = sz*0.8
	local pad = 10
	local b = gui.create( "button", self )
	b:setPos( w - pad - sz , pad )
	b:setSize( sz, sz )
	b:setText( ">" )
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

	self.pnlh =  h - fh - textBorder - border*2
	panel:setSize( w - border*2, self.pnlh )
	panel:setPos( border, fh + textBorder + border )
	function panel:paint( w, h )
		lg.setColor( 44, 44, 44, 255 )
		lg.rectangle( "fill", 0, 0, w, h )
	end

	self.container = panel

	local pw,ph = panel:getSize()
	local px,py = panel:getPos()
	self.panel = gui.create( "panel", panel )
	self.panel:setSize( pw - b*2, ph - b*2 )
	self.panel:setPos( b, b )
	self.panel.paint = function( pnl, w, h  )
		lg.setColor( 11, 11, 11, 255 )
		lg.rectangle( "fill", 0, 0, w, h )
	end
	self:setUpOptions( self.panel:getSize() )
end

local border = 4
function PANEL:setUpOptions( w, h )

	local panel = self.panel

	local opW = w/8
	local opH = h/15
	local res = gui.create( "dropDownMenu", panel )
	res:setSize( opW, opH )
	res:setPos( border, border )
	res:setDefaultText( "800x600" )
	res:addOption(

		"1920x1080",

		function()
			gui.changeResolution( 1920, 1080 )
		end

	)
	res:addOption(

		"1366x768",

		function()
			gui.changeResolution( 1336, 768 )
		end

	)
	res:addOption(

		"1024x768",

		function()
			gui.changeResolution( 1024, 768 )
		end

	)
	res:addOption(

		"800x600",

		function()
			gui.changeResolution( 800, 600 )
		end

	)
	res:addOption(

		"600x400",

		function()
			gui.changeResolution( 600, 400 )
		end

	)

	function res:onSizeChanged( oldw, oldh, w, h )
		local wscale = w/100
		local hscale = h/40
		local median = (wscale+hscale)/2
		self:setFont( love.graphics.newFont( math.round( median*16 ) ) )
	end

end

function PANEL:paint( w, h )

	local dw,dh = love.graphics.getDimensions()
	local pw,ph = self:getSize()

	lg.setColor( 11, 11, 11, 120 )
	lg.rectangle( "fill", 0, 0, w, h )

	lg.setColor( 255, 255, 255, 230 )
	lg.setFont( titleFont )
	local fW,fH = titleFont:getWidth( hText ),titleFont:getHeight( hText )

	local con = self.container
	local conHeight = con:getHeight()
	local cony = con:getY()

	local y = cony - (dh - self.container:getHeight() + border )/2 - fH/2
	lg.print( hText, w/2 - fW/2 ,  y )

end
gui.register( "options", PANEL, "base" )
