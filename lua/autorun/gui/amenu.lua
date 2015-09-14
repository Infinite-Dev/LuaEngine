
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

local buttonD =
{
	{ "New Game", function( self )
		self:getParent():remove()
		game.changeState( "game" )
	end },
	{ "Load", function( self )
		
	end },	
	{ "Highscores", function( self )
		local prnt = self:getParent()
		local w,h = prnt:getSize()
		if not self.scores then
			self.scores = gui.create( "scores", prnt )
			self.scores:setPos( w, 0 )
		end 
		prnt:moveTo( -w, 0, 1, 0.5, 0.5 )
	end },
	{ "Quit", function( self )
		local w,h = self:getParent():getSize()
		local qConfirm = gui.create( "ynBox" )
		qConfirm:setText( "Are you sure?" )
		qConfirm:setSize( w/4, h/5 )
		qConfirm:center()
		function qConfirm:yesFunc()
			love.event.quit( )
		end 
		function qConfirm:noFunc()
			self:remove()
		end 
	end }
}

local padding = 40 
function PANEL:init() 

	self.buttons = {}
	local w, h = love.graphics.getDimensions()
	self:setSize( w, h )
	self:center()

	local bWidth = w/5
	local bHeight = h/10
	local UISpace = h-padding*2
	local gap = UISpace/#buttonD
	for i = 1,#buttonD do

		local tbl = buttonD[ i ]
		local b = gui.create( "button", self )
		local bY = gap*(i-1) + bHeight/2 -- fuk dis gey erth
		b.doClick = tbl[ 2 ]
		b:setSize( bWidth, bHeight )
		b:setPos( w/2 - bWidth/2, bY + padding ) 
		b:setText( tbl[ 1 ] )
		b.clr = 120
		b.alpha = 150
		b.tAlpha = 150

		function b:paint( w, h )

		end 

		function b:onCursorEntered()
			self.tAlpha = 255
		end 

		function b:onCursorExited()
			self.tAlpha = 150
		end 

		function b:think()
			if self.alpha ~= self.tAlpha then
				self.alpha = math.approach( self.alpha, self.tAlpha, 8 )
				b:setTextColor( { self.clr, self.clr, self.clr, self.alpha } )
			end 
		end 

		b:setTextColor( { b.clr, b.clr, b.clr, b.alpha } )
	end 

end 

function PANEL:paint()

	lg.setColor( 11, 11, 11, 120 )
	lg.rectangle( "fill", 0, 0, self:getWide(), self:getTall() )

end
gui.register( "aMenu", PANEL, "panel" )