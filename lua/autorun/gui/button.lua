

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

local defaultFont = lg.newFont( 20 )

function PANEL:_initialize()
	self.__down = false
	self.__down_delay = 0.5
	self.__down_time = 0
	self.__alpha = 240
	self.__color = { 230, 230, 230, 240 }
	self.__textcolor = { 60, 60, 60, 255 }
	self.__gradient = 2
	self.__text = "Click me!"
	self.__canClick = true
	self.__font = defaultFont 
end

function PANEL:setGradient( grad )
	self.__gradient = grad
end

function PANEL:getGradient()
	return self.__gradient
end

function PANEL:setText( text )
	self.__text = text
end

function PANEL:getText( text )
	return self.__text
end

function PANEL:setEnabled( bool )
	self.__enabled = bool 
end 

function PANEL:isEnabled()
	return self.__enabled 
end 

function PANEL:setTextColor( r, g, b, a )
	if type( r ) == "table" then
		self.__textcolor = r
	else
		self.__textcolor = {r, g, b, a}
	end
end

function PANEL:getTextColor()
	return self.__textcolor 
end

function PANEL:setFont( font )
	self.__font = font 
end

function PANEL:getFont()
	return self.__font 
end 

function PANEL:doClick()

end

function PANEL:doRightClick()

end

local key_funcs = 
{
	[ "l" ] = function( pnl )
		if pnl.doClick then
			pnl:doClick()
		end
	end,
	[ "r" ] = function( pnl )
		if pnl.doRightClick then
			pnl:doRightClick()
		end
	end
}
function PANEL:__click( key )
	if key_funcs[ key ] then
		key_funcs[ key ]( self )
	end
	self.__down = true
	self.__down_time = love.timer.getTime() + self.__down_delay
end

function PANEL:paint( w, h )
	local grad = self:getGradient()
	for i = 1,grad do
		lg.setColor( self.__color[ 1 ], self.__color[ 2 ], self.__color[ 3 ], self.__color[ 4 ]/i )
		lg.rectangle( "fill", grad - i, grad - i, w - grad*2 + i*2, h - grad*2 + i*2 )
	end
	lg.setColor( unpack( self.__color ) )
	lg.rectangle( "fill", grad, grad, w-grad*2, h-grad*2 )
end

function PANEL:paintOver( w, h )

	local text = self:getText() or "Click me!"
	local font = self:getFont()

	lg.setFont( font )

	local w2,h2 = font:getWidth( text ),font:getHeight( text )
	lg.setColor( unpack( self:getTextColor() ) )
	lg.print( text, w/2 - w2/2, h/2 - h2/2 )

end

gui.register( "button", PANEL, "base" )

