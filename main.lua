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
	game.drawHUD()
	hook.call( "paint" )
end

--[[----------------------------------------
	Run these functions on tick.
--]]----------------------------------------
function love.update( dt )
	game.think( dt )
end 

function love.mousepressed( x, y, button )
	gui.buttonCheck( x, y, button )
end

local keyFuncs = 
{
	[ "escape" ] = function()
		if game.isPaused() then 
			game.unpause()
			if game.pauseMenu then
				game.pauseMenu:remove()
			end 
		else 
			game.pause()
		end 
	end,
	[ "r" ] = function()
		if game.getState() == "game" then 
			game.restart()
		end 
	end
}
function love.keypressed(key)
	if keyFuncs[ key ] then 
		keyFuncs[ key ]()
	end 
end