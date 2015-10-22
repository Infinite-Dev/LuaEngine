
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

local titleFont = lg.newFont( 20 )

function PANEL:init()
	self.yButton = gui.create( "button", self )
	self.yButton:setText( "Yes" )
	self.yButton.doClick = function( btn )
		self:yesFunc()
	end 

	self.nButton = gui.create( "button", self )
	self.nButton:setText( "No" )
	self.nButton.doClick = function( btn )
		self:noFunc()
	end 
end 

function PANEL:yesFunc()

end 

function PANEL:noFunc()

end 

function PANEL:setText( txt )
	self.__text = txt 
end

function PANEL:getText()
	return self.__text or "Are you sure"
end 

function PANEL:onSizeChanged()
	local w,h = self:getSize()

	local bW,bH = w/4, 30
	self.yButton:setSize( bW, bH )
	self.yButton:setPos( bW/2 , h - h/3 - bH/2 )

	self.nButton:setSize( bW, bH )
	self.nButton:setPos( w - bW*1.5, h - h/3 - bH/2 )
end 

local b = 4
function PANEL:paint( w, h )

	lg.setColor( 44, 44, 44, 240 )
	lg.rectangle( "fill", 0, 0, w, h )

	lg.setColor( 22, 22, 22, 240 )
	lg.rectangle( "fill", b, b, w - b*2, h - b*2 )

	local hText = self:getText()
	lg.setColor( 255, 255, 255, 230 )
	lg.setFont( titleFont )
	local fW,fH = titleFont:getWidth( hText ),titleFont:getHeight( hText )
	lg.print( hText, w/2 - fW/2 , h/3 - fH/2 )

end
gui.register( "ynBox", PANEL, "panel" )