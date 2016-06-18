
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

local start = love.timer.getTime()
local radian = 2*math.pi

local aFont = love.graphics.newFont( 20 )

local astr = "a"
local bstr = "b"
local cstr = "c"

local Astr = "A"
local Bstr = "B"
local Cstr = "C"

local alpham = 6
local alphan = 1
function PANEL:paint( w, h )

	lg.setColor( 235, 235, 235, 255 )

	local a = (start - love.timer.getTime())
	local x, y = w/2, h/2
	local diameter = 500
	local r = diameter/2
	lg.circle( "line", x, y, r )

	-- Moving line.
	lg.setColor( 0, 0, 235, 255 )
	local lcos, lsin =  math.cos( a ), math.sin( a )
	local lx, ly = x + lcos*r, y + lsin*r
	lg.line( x, y, lx, ly )

	-- Static Line
	lg.setColor( 200, 0, 200, 255 )
	local sx, sy = x + math.cos( 0 )*r, y + math.sin( 0 )*r
	lg.line( x, y, sx, sy )

	-- Segment LS
	lg.setColor( 0, 235, 0, 255 )
	lg.line( lx, ly, sx, sy )

	-- Alpha
	lg.setColor( 230, 0, 130, 255 )
	lg.setFont( aFont )

	--[[
	Here comes some maths.
	dividing a line internally by ratio m:n

	( mx2 + nx1 )/(m + n), (my2 + ny1)/( m + n )
	]]--

	local alphax1 = ( alpham*lx + alphan*x)/(alpham + alphan )
	local alphay1 = ( alpham*ly + alphan*y)/(alpham + alphan )

	local alphax2 = ( alpham*lx + alphan*sx)/(alpham + alphan )
	local alphay2 = ( alpham*ly + alphan*sy)/(alpham + alphan )

	local alphamidx = ( alphax1 + alphax2 )/2
	local alphamidy = ( alphay1 + alphay2 )/2

	local fSizex, fSizey = aFont:getWidth( astr ), aFont:getHeight( astr )
	lg.print( astr, alphamidx, alphamidy, 0, 1, 1, fSizex/2, fSizey/2 )

	lg.setColor( 220, 0, 0, 255 )
	local rotations = math.floor( a/radian ) + 1
	local arcAngle = a - radian*rotations
	if -arcAngle < radian*0.999 and -arcAngle > radian*0.001 then
		lg.arc( "line", x, y, r/10, arcAngle, 0, 36 )
	end

	lg.setColor( 200, 80, 0, 255 )
	local midx, midy = (lx + sx)/2, (ly + sy)/2
	lg.line( x, y, midx, midy )

end

gui.register( "trig", PANEL, "base" )
