--[[----------------------------------------
	LoadFiles( directory )
	Loads files from the specified directory.
--]]----------------------------------------

function loadFiles( dir )
	local objects = love.filesystem.getDirectoryItems( dir )
	local tbl = {}
	for i = 1,#objects do
		if love.filesystem.isDirectory( dir.."/"..objects[ i ] ) then
			tbl[ #tbl + 1 ] = dir.."/"..objects[ i ]
		else 
			local name = dir.."/"..string.sub( objects[ i ], 0, string.len( objects[ i ] ) - 4 )
			require( name )
		end
	end
	
	for i = 1,#tbl do
		loadFiles( tbl[ i ] )
	end
end

function love.load()
	loadFiles( "lua/autorun" )
	game.changeState( "menu" )
end 

--[[----------------------------------------
	Call our basic draw functions and call 
	the draw hook.
--]]----------------------------------------

function love.draw()
	gui.draw()
	ents.draw()
	hook.call( "paint" )
end

--[[----------------------------------------
	Run these functions on tick.
--]]----------------------------------------
function love.update( dt )
	game.think()
end 

--[[----------------------------------------
	Check to see if we clicked on a gui panel.
--]]----------------------------------------

function GUICheck( x, y, button )
	local in_area = util.isInArea
	for k, panel in pairs( gui.objects ) do
		local p_x,p_y = panel:getPos()
		local p_w,p_h = panel:getSize()
		if in_area( x, y, p_x, p_y, p_w, p_h ) then
			panel:__click( button )
		end
	end
end

function love.mousepressed( x, y, button )
	GUICheck( x, y, button )
end

