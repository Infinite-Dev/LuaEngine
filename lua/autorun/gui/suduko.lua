
--[[--
 ▄▀▀█▄▄   ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀▄ ▀▀▄  ▄▀▀▄ ▀▄  ▄▀▄▄▄▄
█ ▄▀   █ ▐  ▄▀   ▐ █ █   ▐ █   ▀▄ ▄▀ █  █ █ █ █ █    ▌
▐ █    █   █▄▄▄▄▄     ▀▄   ▐     █   ▐  █  ▀█ ▐ █
  █    █   █    ▌  ▀▄   █        █     █   █    █
 ▄▀▄▄▄▄▀  ▄▀▄▄▄▄    █▀▀▀       ▄▀    ▄▀   █    ▄▀▄▄▄▄▀
█     ▐   █    ▐    ▐          █     █    ▐   █     ▐
▐         ▐                    ▐     ▐        ▐
--]]--

local math = math
local lg = love.graphics
local lm = love.mouse
local PANEL = {}

local aFont = love.graphics.newFont( 20 )

local numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, selected = false, number = false }
local gridSize = 9
local grid = {}
for i = 1,(gridSize^2) do
	grid[ i ] = table.copy( numbers )
end

local subGridSize = 3

love.math.setRandomSeed( os.time() )

function resetGrid()
	for i = 1,(gridSize^2) do
		grid[ i ] = table.copy( numbers )
	end
end

local floor = math.floor
local ceil = math.ceil
function removeGridValues( i, n )
	if n == nil then
		return
	end
	grid[ i ][ n ] = false
	grid[ i ].selected = true
	grid[ i ].number = n

	local a = floor( (i-1)/gridSize )
	for i2 = 1,(#grid) do
		local a2 = floor( (i2-1)/gridSize )
		if a == a2 then
			grid[ i2 ][ n ] = false
		end
		if i2 - a2*gridSize == i - a*gridSize then
			grid[ i2 ][ n ] = false
		end
		local b = ceil( (i - a*gridSize)/subGridSize )
		local b2 = ceil( (i2 - a2*gridSize)/subGridSize )

		local b3 = floor( a/subGridSize )
		local b4 = floor( a2/subGridSize )


		if ( b == b2 ) and (b3 == b4) then
			grid[ i2 ][ n ] = false
		end
	end
end

function selectGridValue( targ )
	local list = {}
	local values = false
	for i = 1,#grid do
		if not grid[ i ].selected then
			list[ #list+1 ] = i
			for i2 = 1,#grid[ i ] do
				if type( grid[ i ][ i2 ] ) == "number" then
					values = true
					break
				end
			end
			if not values then
				return
			end
		end
	end

	local rnd = love.math.random( 1, #list )
	local rndSquare = targ or list[ rnd ]
	local list2 = {}
	for k,v in pairs( grid[ rndSquare ] ) do
		if targ then
			--print( "FOR "..targ )
			--print( "VALUE FOR KEY "..k.." is: "..tostring(v) )
		end
		if type( v ) == "number" then
			list2[ #list2 + 1 ] = v
		end
	end

	local rnd2 = love.math.random( 1, #list2 )
	removeGridValues( rndSquare, list2[ rnd2 ] )
end

function beginGridGen()
	for i = 1,#grid do
		selectGridValue()
	end
end

local record = 0
local delay = 0
function PANEL:think()
end

local boxSize = 30
function PANEL:paint( w, h )

	local complete = true
	for i2 = 1,#grid do
		if not grid[ i2 ].number then
			complete = false
		end
	end
	if not complete then
		resetGrid()
		beginGridGen()
		local total = 0
		for k,v in pairs( grid ) do
			if v.number then
				total = total + 1
			end
		end
		local finRatio = total/(gridSize^2)
		if finRatio > record then
			record = finRatio
			print( "NEW RECORD: "..(finRatio*100) )
		end
	end

	-- lg.setColor( 255, 255, 255, 255 )
	-- local startx = w/2 - boxSize*gridSize/2
	-- local starty = h/2 - boxSize*gridSize/2
	--
	-- for i = 1,gridSize^2 do
	-- 	local a = math.floor( (i-1)/gridSize )
	-- 	local x = ((i-1) - a*gridSize)*boxSize
	-- 	local y = a*boxSize
	-- 	lg.setColor( 0, 255*( a/gridSize ), 255*( ((i-1) - a*gridSize)/gridSize ) )
	-- 	lg.rectangle( "line", startx + x, starty + y, boxSize, boxSize )
	-- end
	--
	-- local i2 = math.random( 1, #grid )
	-- local a2 = math.floor( (i2-1)/gridSize )
	-- for i = 1,(gridSize^2) do
	-- 	local a = math.floor( (i-1)/gridSize )
	-- 	if a == a2 then
	--
	-- 	end
	-- 	if i2 - a2*gridSize == i - a*gridSize then
	--
	-- 	end
	-- 	local b = math.ceil( ((i) - a*gridSize)/subGridSize )
	-- 	local b2 = math.ceil( ((i2) - a2*gridSize)/subGridSize )
	--
	-- 	local b3 = math.floor( a/subGridSize )
	-- 	local b4 = math.floor( a2/subGridSize )
	--
	--
	-- 	if ( b == b2 ) and (b3 == b4) then
	-- 		local x = ((i-1) - a*gridSize)*boxSize
	-- 		local y = a*boxSize
	-- 		lg.setColor( 0, 255*( a/gridSize ), 255*( ((i-1) - a*gridSize)/gridSize ) )
	-- 		lg.rectangle( "fill", startx + x, starty + y, boxSize, boxSize )
	-- 	end
	--
	-- end
	--
	-- for i = 1,gridSize do
	-- 	local y = boxSize*( i - 1 )
	-- 	for i2 = 1,gridSize do
	-- 		local x = boxSize*( i2 - 1 )
	-- 		--lg.rectangle( "line", startx + x, starty + y, boxSize, boxSize )
	-- 		local gridpos = (i-1)*gridSize + i2
	-- 		if grid and grid[ gridpos ] then
	-- 			if grid[ gridpos ].selected then
	-- 				lg.setColor( 255, 255, 255, 255 )
	-- 				lg.setFont( aFont )
	-- 				local width,height = aFont:getWidth( grid[ gridpos ].number ), aFont:getHeight( grid[ gridpos ].number )
	-- 				lg.print( grid[ gridpos ].number, startx + x + width/2, starty + y + height/4)
	-- 			end
	-- 		end
	-- 	end
	-- end

end

gui.register( "suduko", PANEL, "base" )
