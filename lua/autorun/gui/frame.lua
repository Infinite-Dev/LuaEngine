
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

function PANEL:_Initialize() 
	local w,h = self:GetSize()
	self.close_btn = gui.Create( "Button", self )
	self.close_btn:SetSize( b_sz, b_sz )
	self.close_btn:SetPos( 0, 0 )
	self.close_btn:SetText( "X" )
	self.close_btn.DoClick = function()
		self.close_btn:GetParent():Remove()
	end
	
	self:SetTitleColor( {255, 255, 255, 255 } )
end

function PANEL:OnSizeChanged()
	local w,h = self:GetSize()
	self.close_btn:SetPos( w - b_sz - b_gap , b_gap )
end

function PANEL:SetTitle( text )
	self.__title = text
end

function PANEL:SetFont( font )

end

function PANEL:SetTitleColor( r, g, b, a )
	if type(r) == "table" then 
		self.__titlecolor = {unpack( r )}
	else
		self.__titlecolor = { r, g, b, a }
	end
end

function PANEL:GetTitle()
	return self.__title
end

function PANEL:PaintOver()
	local title = self:GetTitle() or "Title"
	local font = love.graphics.getFont()
	local w,h = font:getWidth( title ),font:getHeight( title )
	lg.setColor( unpack( self.__titlecolor) )
	lg.print( title, 5, 5 )
end

gui.Register( "Frame", PANEL, "Base" )