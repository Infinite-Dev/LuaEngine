

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
	self.__down = false
	self.__down_delay = 2
	self.__down_time = 0
	self.__alpha = 240
	self.__color = { 230, 230, 230, 240 }
	self.__textcolor = { 120, 120, 120, 255 }
	self.__gradient = 2
	self.__text = "Click me!"
	self.__CanClick = true
end

function PANEL:SetGradient( grad )
	self.__gradient = grad
end

function PANEL:GetGradient()
	return self.__gradient
end

function PANEL:SetText( text )
	self.__text = text
end

function PANEL:GetText( text )
	return self.__text
end

function PANEL:SetTextColor( r, g, b, a )
	if type( r ) == "table" then
		self.__textcolor = r
	else
		self.__textcolor = {r, g, b, a}
	end
end

function PANEL:GetTextColor()
	return self.__textcolor 
end

function PANEL:SetFont()

end

function PANEL:DoClick()

end

function PANEL:DoRightClick()

end

local key_funcs = 
{
	[ "l" ] = function( pnl )
		if pnl.DoClick then
			pnl:DoClick()
		end
	end,
	[ "r" ] = function( pnl )
		if pnl.DoRightClick then
			pnl:DoRightClick()
		end
	end
}
function PANEL:__Click( key )
	if key_funcs[ key ] then
		key_funcs[ key ]( self )
	end
	self.__down = true
	self.__down_time = love.timer.getTime() + self.__down_delay
end

function PANEL:Paint( w, h )
	local grad = self:GetGradient()
	for i = 1,grad do
		lg.setColor( self.__color[ 1 ], self.__color[ 2 ], self.__color[ 3 ], self.__color[ 4 ]/i )
		lg.rectangle( "fill", grad - i, grad - i, w - grad*2 + i*2, h - grad*2 + i*2 )
	end
	lg.setColor( unpack( self.__color ) )
	lg.rectangle( "fill", grad, grad, w-grad*2, h-grad*2 )
end

function PANEL:PaintOver( w, h )
	local text = self:GetText() or "Click me!"
	local font = love.graphics.getFont()
	local w2,h2 = font:getWidth( text ),font:getHeight( text )
	lg.setColor( unpack( self:GetTextColor() ) )
	lg.print( text, w/2 - w2/2, h/2 - h2/2 )
end

gui.Register( "Button", PANEL, "Base" )

