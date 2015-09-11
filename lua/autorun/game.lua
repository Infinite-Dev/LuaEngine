
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

function game.beginContact( a, b, coll )
	hook.call( "beginContact", a, b, coll )
end 

function game.endContact( a, b, coll )
	hook.call( "endContact", a, b, coll )
end 

function game.preSolve( a, b, coll )
	hook.call( "preSolve", a, b, coll )
end 

function game.postSolve( a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2 )
	hook.call( "postSolve", a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2 )
end 

function game.setWorld( world )
	world:setCallbacks( game.beginContact, game.endContact, game.preSolve, game.postSolve )
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

		game.setUp()

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


function game.setUp()
	love.keyboard.setKeyRepeat(true)
	for i = 1,4 do 
		local ast = ents.create( "ent_asteroids" )
		ast:setPos( math.random( 30, 400 ), math.random( 30, 400 ) )
		ast:setMinMax( 40, 60 )
		ast:setSize()
		ast:generate()

		local mul = ast.r*100
		ast:moveRandom( mul )
	end 

	local ply = ents.create( "ent_player" )
	ply:setPos( 400, 400 )
end 