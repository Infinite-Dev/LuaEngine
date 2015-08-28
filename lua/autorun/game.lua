
game = {}
game.paused = false 
game.states = {}
function game.pause()
	game.paused = true 
end 

function game.unpause()
	game.paused = false
end 

function game.isPaused()
	return game.paused 
end 

function game.changeState( state )
	local func = game.states.changeFuncs[ state ]
	local tFunc = game.states.thinkFuncs[ state ]
	if func then
		func()
	end 
	game.think = tFunc 
end

function game.stop()

end

function game.getWorld()
	return game.__world 
end 

function game.setWorld( world )
	game.__world = world 
end 

game.states.changeFuncs =
{
	paused = function()
		local resume = gui.create( "DButton" )
		resume:setSize( 40, 20 )
		resume:Centre()
		resume:setText( "Resume" )
		resume.doClick = function()
			game.changeState( "running" )
		end
		game.pause()
	end,
	game = function()
		game.unpause()

		love.physics.setMeter(64)
		game.setWorld( love.physics.newWorld( 0, 0, true ) )

		local ast = ents.create( "ent_asteroids" )
		ast:setPos( 400, 300 )

		local top = ents.create( "ent_boundrytop" )
		local left = ents.create( "ent_boundryleft" )
		local bottom = ents.create( "ent_boundrybottom" )
		local right = ents.create( "ent_boundryright" )

	end,
	menu = function()
		local mainMenu = gui.create( "aMenu" )
		game.stop()
	end 
} 

game.states.thinkFuncs = 
{
	paused = function()
		gui.update()
	end, 
	game = function()
		gui.update()
		timer.think()
		ents.think()
		game.getWorld():update( love.timer.getDelta() )
		hook.call( "Think" )
	end,
	menu = function()
		gui.update()
		timer.think()
		hook.call( "Think" )
	end 
}
