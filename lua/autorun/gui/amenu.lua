
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
	{ "New Game", function( self)
		game.changeState( "game" )
	end },

	{ "Load", function()
		game.changeState( "game" )
	end },	
	{ "Highscores", function( self )
		local prnt = self:GetParent()
		local w,h = prnt:GetSize()
		local scores = gui.Create( "scores", prnt )
		
		scores:SetPos( w, 0 )
		prnt:moveTo( -w, 0, 1 )

	end },
	{ "Quit", function()
		game.changeState( "game" )
	end }
}

local padding = 40 
function PANEL:Init() 

	self.buttons = {}
	local w, h = love.graphics.getDimensions()
	self:SetSize( w, h )
	self:Center()

	local bWidth = w/5
	local bHeight = h/10
	local UISpace = h-padding*2
	local gap = UISpace/#buttonD
	for i = 1,#buttonD do

		local tbl = buttonD[ i ]
		local b = gui.Create( "Button", self )
		local bY = gap*(i-1) + bHeight/2 -- fuk dis gey erth
		b.DoClick = tbl[ 2 ]
		b:SetSize( bWidth, bHeight )
		b:SetPos( w/2 - bWidth/2, bY + padding ) 
		b:SetText( tbl[ 1 ] )
		b.clr = 120
		b.alpha = 150
		b.tAlpha = 150

		function b:Paint( w, h )

		end 

		function b:OnCursorEntered()
			self.tAlpha = 255
		end 

		function b:OnCursorExited()
			self.tAlpha = 150
		end 

		function b:Think()
			if self.alpha ~= self.tAlpha then
				self.alpha = math.approach( self.alpha, self.tAlpha, 8 )
				b:SetTextColor( { self.clr, self.clr, self.clr, self.alpha } )
			end 
		end 

		b:SetTextColor( { b.clr, b.clr, b.clr, b.alpha } )
	end 

end 

function PANEL:Paint()

	lg.setColor( 11, 11, 11, 120 )
	lg.rectangle( "fill", 0, 0, self:GetWide(), self:GetTall() )

end
gui.Register( "aMenu", PANEL, "Panel" )