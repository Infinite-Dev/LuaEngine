
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
local b_sz = 14
local b_gap = 2

local dFont = lg.newFont( 12 )
function PANEL:_initialize() 
	local w,h = self:getSize()
	self.close_btn = gui.create( "button", self )
	self.close_btn:setSize( b_sz, b_sz )
	self.close_btn:setPos( 0, 0 )
	self.close_btn:setText( "x" )
	self.close_btn:setTextColor( 255, 255, 255, 255 )
	self.close_btn.doClick = function()
		self.close_btn:getParent():remove()
	end
	self.close_btn.paint = function( but, w, h )

	end 
	
	self:setTextColor( {255, 255, 255, 255 } )
end

function PANEL:onSizeChanged()
	local w,h = self:getSize()
	self.close_btn:setPos( w - b_sz - b_gap , b_gap )
end

function PANEL:setTitle( text )
	self.__title = text
end

function PANEL:setFont( font )

end

function PANEL:setTextColor( r, g, b, a )
	if type(r) == "table" then 
		self.__titlecolor = {unpack( r )}
	else
		self.__titlecolor = { r, g, b, a }
	end
end

function PANEL:getTitle()
	return self.__title
end

local b = 4
local b2 = 22
function PANEL:paint( w, h )
	lg.setColor( 44, 44, 44, 255 )
	lg.rectangle( "fill", 0, 0, w, h )
	lg.setColor( 22, 22, 22, 255  )
	lg.rectangle( "fill", b, b2, w - b*2, h - b2 - b )
end 

function PANEL:paintOver()
	local title = self:getTitle() or "Title"
	lg.setFont( dFont )
	local w,h = dFont:getWidth( title ),dFont:getHeight( title )
	lg.setColor( unpack( self.__titlecolor) )
	lg.print( title, 5, 5 )
end

gui.register( "frame", PANEL, "base" )