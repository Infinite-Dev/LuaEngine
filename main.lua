--[[----------------------------------------
	LoadFiles( directory )
	Loads files from the specified directory.
--]]----------------------------------------

function LoadFiles( dir )
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
		LoadFiles( tbl[ i ] )
	end
end

function love.load()
	LoadFiles( "lua/autorun" )
	game.changeState( "menu" )
end 

--[[----------------------------------------
	Call our basic draw functions and call 
	the draw hook.
--]]----------------------------------------

function love.draw()
	gui.Draw()
	hook.Call( "Paint" )
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
	local in_area = util.IsInArea
	for k, panel in pairs( gui.Objects ) do
		local p_x,p_y = panel:GetPos()
		local p_w,p_h = panel:GetSize()
		if in_area( x, y, p_x, p_y, p_w, p_h ) then
			panel:__Click( button )
		end
	end
end

function love.mousepressed( x, y, button )
	GUICheck( x, y, button )
end

