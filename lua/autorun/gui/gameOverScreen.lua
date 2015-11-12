
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

function PANEL:createButton()
	local w,h = self:getSize()
	local master = self 


	local font = love.graphics.newFont( 40 )
	local bw,bh = w/1.3,h/2
	self.label = gui.create( "label", self )
	self.label:setSize( bw, bh )
	self.label:setPos( w/2 - bw/2, h/2 - bh/2 )
	self.label:setText( "GAME OVER" )
	self.label:setFont( font )
	self.label:setWrap( true )
	self.label:setTextAlignment( TEXT_CENTRE, TEXT_TOP )


	local bfont = love.graphics.newFont( 18 )
	local bw,bh = w/2.5,h/6
	self.retry = gui.create( "button", self )
	self.retry:setPos( w/4 - bw/2, h - bh - 10)
	self.retry:setSize( bw, bh )
	self.retry:setText( "R to Restart" )
	self.retry:setFont( bfont )
	function self.retry:doClick()
		game.restart()
	end 

	self.quit = gui.create( "button", self )
	self.quit:setPos( w - w/4 - bw/2, h - bh - 10)
	self.quit:setSize( bw, bh )
	self.quit:setText( "Q to Quit" )
	self.quit:setFont( bfont )
	function self.quit:doClick()
		game.changeState( "menu" )
		self:getParent():remove()
	end 

end

local border = 3 
function PANEL:paint( w, h )
	lg.setColor( 22, 22, 22, 255 )
	lg.rectangle( "fill", 0, 0, w, h )

	lg.setColor( 11, 11, 11, 255 )
	lg.rectangle( "fill", border, border, w - border*2, h - border*2 )
end
gui.register( "gameOverScreen", PANEL, "base" )