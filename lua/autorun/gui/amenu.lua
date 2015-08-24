
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
	{ "New Game", function()
		game.changeState( "game" )
	end },

	{ "Load", function()
		game.changeState( "game" )
	end },	
	{ "Highscores", function()
		game.changeState( "game" )
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
		b.clr = 88
		b.alpha = 180
		b.tAlpha = 180

		function b:Paint( w, h )

		end 

		function b:OnCursorEntered()
			self.tAlpha = 255
		end 

		function b:OnCursorExited()
			self.tAlpha = 180
		end 

		function b:Think()
			if self.alpha ~= self.tAlpha then
				self.alpha = math.approach( self.alpha, self.tAlpha, 2 )
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