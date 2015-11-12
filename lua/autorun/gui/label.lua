
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

local defaultFont = love.graphics.newFont( 20 )
function PANEL:_initialize()
	self:setFont( defaultFont )
	self:setText( "label" )
	self:setTextColor( 255, 255, 255, 255 )
	self:setTextAlignment( TEXT_CENTRE, TEXT_CENTRE )
	self:setTextOffset( 0, 0 )
end

function PANEL:setText( t )
	self.__text = t
	self:cacheWrappedText( t )
end 

function PANEL:getText()
	return self.__text 
end 

function PANEL:setWrap( b )
	self.__wrap = b 
end 

function PANEL:getWrap()
	return self.__wrap 
end 

--[[--
	t - Text
	f - Font 
	cstring - The current string for the iteration.
	s - The concacted strings.
--]]--
function PANEL:cacheWrappedText( t )

	local w,h = self:getSize()
	local tbl = string.explode( t, " " )
	local f = self:getFont()

	if f:getWidth( t ) < w then 
		self.__wraptable = { t }
		return 
	end 

	local strtbl = {}
	local cstring = ""
	for i = 1,#tbl do 
		local s = #cstring > 0 and cstring.." "..tbl[ i ] or tbl[ i ]
		local tw = f:getWidth( s )

		if tw > w then 
			strtbl[ #strtbl+1 ] = cstring
			cstring = tbl[ i ]
		else
			cstring = s 
		end 

		if i == #tbl then
			strtbl[ #strtbl + 1 ] = cstring
		end 

	end
	self.__wraptable = strtbl 

end 

function PANEL:getWrapTable()
	return self.__wraptable or {self:getText()}
end	

function PANEL:drawOutline()
	return self.__outline 
end 

function PANEL:setDrawOutline( b )
	self.__outline = b 
end 

function PANEL:setFont( font )
	self.__font = font 
	self:cacheWrappedText( self:getText() or "" )
end 

function PANEL:getFont()
	return self.__font 
end

function PANEL:setTextColor( r, g, b, a )
	self.__color = { r, g, b, a }
end

function PANEL:getTextColor()
	return self.__color 
end 

TEXT_CENTRE = 0
TEXT_LEFT = 1
TEXT_RIGHT = 2
TEXT_TOP = 1
TEXT_BOTTOM = 2

function PANEL:setTextAlignment( x, y )
	self.__textalignx = x
	self.__textaligny = y
end 

function PANEL:getTextAlignment()
	return self.__textalignx, self.__textaligny
end 

function PANEL:setTextOffset( x, y )
	self.__xoffset = x 
	self.__yoffset = y 
end 

function PANEL:getTextOffset()
	return self.__xoffset, self.__yoffset 
end 

function PANEL:getXOffset()
	return self.__xoffset 
end 

function PANEL:getYOffset()
	return self.__yoffset 
end 

local xposFunctions =
{
	[ TEXT_CENTRE ] = function( w, s, f )
		local tw = f:getWidth( s )
		return w/2 - tw/2 
	end,
	[ TEXT_LEFT ] = function( w, s, f )
		return 0 
	end, 
	[ TEXT_RIGHT ] = function( w, s, f )
		local tw = f:getWidth( s )
		return w - tw
	end 	
}

local gap = 4 
local yposFunctions =
{
	[ TEXT_CENTRE ] = function( h, s, f, n )

		if not n then 
			n = 1
		end 

		local sh = f:getHeight( s )
		local totalHeight = n > 1 and (sh+gap)*n or sh 

		return h/2 - totalHeight/2 

	end,
	[ TEXT_TOP ] = function( h, s, f, n )

		return 0

	end, 
	[ TEXT_BOTTOM ] = function( h, s, f, n )

		if not n then 
			n = 1 
		end 

		local sh = f:getHeight( s )
		local totalHeight = n > 1 and (sh+gap)*n or sh 

		return h - totalHeight

	end 	
}
function PANEL:getTextPos( s, n )
	local xal,yal = self:getTextAlignment()
	local f = self:getFont()
	local xo,yo = self:getTextOffset()
	return xposFunctions[ xal ]( self:getWidth(), s, f ) + xo, yposFunctions[ yal ]( self:getHeight(), s, f, n ) + yo
end 

function PANEL:paintOver( w, h )

	love.graphics.setColor( unpack( self:getTextColor() ) )
	if self:getWrap() then 
		local tbl = self:getWrapTable()
		local f = self:getFont()
		love.graphics.setFont( f )
		for i = 1,#tbl do 
			local text = tbl[ i ]
			local x,y = self:getTextPos( text, #tbl )
			local th = f:getHeight( text ) + gap
			love.graphics.print( text, x, y + th*(i-1) )
		end 
	else 
		local x,y = self:getTextPos()
		local f = self:getFont()
		love.graphics.setFont( f )
		love.graphics.print( self:getText(), x, y )
	end 

	if self:drawOutline() then 
		love.graphics.setColor( 255, 255, 255, 255 )
		love.graphics.rectangle( "line", 0, 0, w - 0.5, h )
	end 
end 

function PANEL:paint() end

gui.register( "label", PANEL, "base" )
