
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

local titleFont = lg.newFont( "resources/fonts/FREEDOM.ttf", 40 )

function PANEL:init()
	local w, h = love.graphics.getDimensions()
	self:setSize( w, h )

	local prnt = self:getParent()

	local sz = 40
	local csz = sz*0.8
	local pad = 10
	local b = gui.create( "button", self )
	b:setPos( pad, pad )
	b:setSize( sz, sz )
	b:setText( "<-" )
	function b:paint( w, h )
		lg.setColor( 255, 255, 255, 220 )
		love.graphics.circle( "line", w/2, w/2, csz/2, 100 )
	end
	function b:doClick()
		prnt:moveTo( 0, 0, 1, 0.5, 0.5 )
	end  
end 

local hText = "HIGHSCORES"
function PANEL:paint( w, h )

	lg.setColor( 11, 11, 11, 120 )
	lg.rectangle( "fill", 0, 0, w, h )

	lg.setColor( 255, 255, 255, 230 )
	lg.setFont( titleFont )
	local fW,fH = titleFont:getWidth( hText ),titleFont:getHeight( hText )
	lg.print( hText, w/2 - fW/2 , h/10 )

end
gui.register( "scores", PANEL, "base" )