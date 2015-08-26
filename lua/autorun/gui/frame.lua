
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

function PANEL:_initialize() 
	local w,h = self:getSize()
	self.close_btn = gui.create( "button", self )
	self.close_btn:setSize( b_sz, b_sz )
	self.close_btn:setPos( 0, 0 )
	self.close_btn:setText( "X" )
	self.close_btn.doClick = function()
		self.close_btn:getParent():remove()
	end
	
	self:SetTitleColor( {255, 255, 255, 255 } )
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

function PANEL:setTitleColor( r, g, b, a )
	if type(r) == "table" then 
		self.__titlecolor = {unpack( r )}
	else
		self.__titlecolor = { r, g, b, a }
	end
end

function PANEL:getTitle()
	return self.__title
end

function PANEL:paintOver()
	local title = self:GetTitle() or "Title"
	local font = love.graphics.getFont()
	local w,h = font:getWidth( title ),font:getHeight( title )
	lg.setColor( unpack( self.__titlecolor) )
	lg.print( title, 5, 5 )
end

gui.register( "frame", PANEL, "base" )