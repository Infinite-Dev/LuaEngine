
game = {}
game.paused = false 
game.states = {}
game.state = ""
function game.pause()
	game.paused = true 
	game.pauseMenu = gui.create( "pMenu" )
end 

function game.unpause()
	game.paused = false
end 

function game.isPaused()
	return game.paused 
end 

function game.getState()
	return game.state 
end 

function game.changeState( state )
	local func = game.states.changeFuncs[ state ]
	local tFunc = game.states.thinkFuncs[ state ]
	if func then
		func()
	end 
	game.state = state 
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

local p = pairs 
function game.postSolve( a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2 )
	local ent1
	local ent2 
	for k,v in p( ents.getAll() ) do
		local f = v:getFixture()
		if f then 
			if f == a then 
				ent1 = v
			elseif f == b then 
				ent2 = v
			end 
		end 
	end 

	if ent1 then 
		ent1:collisionPostSolve( ent2 or b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2 )
	end 

	if ent2 then 
		ent2:collisionPostSolve( ent1 or a, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2 )
	end 
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
		game.cleanUp()

	end 
} 

game.states.thinkFuncs = 
{
	paused = function()
		gui.update()
	end, 
	game = function( dt )
		gui.update()
		timer.think()
		if not game.isPaused() then 
			ents.think()
			game.logic()
			game.getWorld():update( 0.027 )
		end 
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
	for i = 1,asteroids.max do 
		asteroids.createNewAsteroid()
	end 

	game.player = ents.create( "ent_player" )
	game.player:setPos( 400, 400 )
end 

function game.cleanUp()
	for k,v in pairs( ents.getAll() ) do 
		v:remove()
	end
	local w = game.getWorld()
	if w then 
		w:destroy() 
	end 
end

function game.restart()
	game.cleanUp()
	game.changeState( "game" )
end 

function game.logic()
	local numRoids = 0
	for k,v in pairs( ents.getAll() ) do 
		if v:getClass() == "ent_asteroid" then 
			if v.r > asteroids.minSize then 
				numRoids = numRoids + 1 
			end 
		end 
	end 

	local t = love.timer.getTime()
	if numRoids < asteroids.max then 
		for i = 1,(asteroids.max-numRoids) do 
			if t > asteroids.lastDelayTime then 
				asteroids.createNewAsteroid()
				asteroids.lastDelayTime = t + asteroids.delay 
			end 
		end 
	end 
end 
	

local lg = love.graphics 
local barw = 150
local barh = 13
local x = 25
local y = 15
function game.drawHUD()
	if game.player and game.getState() == "game" then 
		local w,h = love.graphics.getDimensions()
		lg.setColor( 255, 50, 50, 255 )
		lg.rectangle( "line", x, y, barw, barh )

		local hp = game.player:getHealth()
		local maxHP = 100 
		local p = hp/maxHP
		lg.rectangle( "fill", x, y, barw*p, barh )
	end
end

function game.generateBackground()
	local tbl = {}
	
end 

function game.drawBackground()

end 
