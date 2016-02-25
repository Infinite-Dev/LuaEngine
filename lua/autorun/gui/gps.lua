 
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

function PANEL:init()
	local scrw,scrh =  love.graphics.getDimensions()
	self:setSize( scrw*0.9, scrh*0.9 )
	self:center()
end 

local c = 30
local b = 0.05
local backColor = { 0, 0, 0, 255 }
local mainColor = { 22, 22, 22, 255 }
function PANEL:paint( w, h )

	love.graphics.setColor( unpack( mainColor ) )
	draw.roundedRect( 0, 0, w, h, c + 10 )

	love.graphics.setColor( unpack( backColor ) )
	draw.roundedRect( w*b, h*b, w - 2*(w*b), h - 2*(h*b) )

end 

gui.register( "gps", PANEL, "panel" )