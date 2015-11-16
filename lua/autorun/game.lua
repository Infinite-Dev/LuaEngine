
game = {}
game.paused = false 
game.states = {}
game.state = ""
game.__curScore = 0
game.__highScore = 0
game.__spawnTime = 0
game.__wave = 1 

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

		game.setNextSpawn( 0 )
		game.setWave( 1 )

	end,
	menu = function()

		local mainMenu = gui.create( "aMenu" )
		game.cleanUp()
		game.generateBackground()

		if game.endGame then 
			game.endGame:remove()
		end

		hook.remove( "think", "playerDeathDelay" )

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
			game.getWorld():update( dt )
		end 
		hook.call( "think" )
	end,
	menu = function()
		gui.update()
		timer.think()
		hook.call( "think" )
	end 
}


function game.getPlayer()
	return game.player 
end 

function game.setUp()
	love.keyboard.setKeyRepeat(true)

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
	if game.endGame then 
		game.endGame:remove()
	end
	hook.remove( "think", "playerDeathDelay" )
end 


local posFuncs =
{
	function( w, h )
		local w,h = love.graphics.getDimensions()
		local x = love.math.random( 0, w )
		local y = -h*1.1
		return x,y
	end, 	
	function( w, h )
		local _,scrh = love.graphics.getDimensions()
		local x = love.math.random( 0, w )
		local y = scrh + h*1.1
		return x,y
	end, 	
	function( w, h )
		local scrw,_ = love.graphics.getDimensions()
		local x = -w*1.1
		local y = love.math.random( 0, h )
		return x,y  
	end, 	
	function( w, h )
		local scrw,_ = love.graphics.getDimensions()
		local x = scrw + w*1.1
		local y = love.math.random( 0, h )
		return x,y 
	end
}
function game.getSpawnPosition( ent )
	local x1,y1,x2,y2 = ent:getBoundingBox()
	local w,h = x2-x1,y2-y1
	local p = love.math.random( 1, 4 )
	local x,y = posFuncs[ p ]( w, h )
	return x,y 
end 

function game.createEnemy( class )
	if class == "ent_asteroid" then 
		asteroids.createNewAsteroid()
	else
		local ent = ents.create( class )
		local x,y = game.getSpawnPosition( ent )
		ent:setPos( x, y )
		ent:spawn()
 	end 
end 

function game.logic()
	if game.shouldSpawn() then 

		local data = game.getWaveData()
		for i = 1,#data do 
			local enemyData = data[ i ]
			for i2 = 1,enemyData[ 1 ] do 
				game.createEnemy( enemyData[ 2 ] )
			end 
		end 

		game.nextWave()
		game.setNextSpawn()

	end
end 

local lg = love.graphics 
local bossFont = lg.newFont( 30 )
local bossFontSmall = lg.newFont( 15 )
local barw = 150
local barh = 13
local x = 25
local y = 15
function game.drawHUD()
	if game.player and game.getState() == "game" then 
		local w,h = love.graphics.getDimensions()

		local hp = game.player:getHealth()
		local maxHP = asteroids.playerHealth
		local p = hp/maxHP
		local c = { 30 + 225*(1-p), 30 + 225*p, 30, 255}

		lg.setColor( unpack( c ) )
		lg.rectangle( "line", x, h - y - barh , barw, barh )

		lg.setColor( unpack( c ) )
		lg.rectangle( "fill", x, h - y - barh, barw*p, barh )

		local bosstbl = {}
		for k,v in pairs (npc.getAll()) do 
			if v:isBoss() then 
				bosstbl[ #bosstbl+1 ] = { v:getName(), v:getDescription(), v:getHealth(), v:getMaxHealth() }
			end 
		end 

		local bossw = w*0.6 
		local bossh = 20
		for i = 1,#bosstbl do 
			local name = bosstbl[ i ][ 1 ]
			local desc = bosstbl[ i ][ 2 ]
			local hp = bosstbl[ i ][ 3 ]
			local maxhp = bosstbl[ i ][ 4 ]
			local p = hp/maxhp 
			lg.setColor( 255, 255, 255, 255 )
			lg.setFont( bossFont )
			local nameW,nameH = bossFont:getWidth( name ),bossFont:getHeight( name )
			local y = nameH/2 + 60*(i-1)
			lg.print( name, w/2 - nameW/2, y )

			local y = y + nameH + 4
			lg.setColor( 210, 50, 50, 255 )
			lg.rectangle( "line", w/2 - bossw/2, y, bossw, bossh )
			lg.rectangle( "fill", w/2 - bossw/2, y, bossw*p, bossh )

			local y = y + bossh
			lg.setColor( 255, 255, 255, 255 )
			lg.setFont( bossFontSmall )
			local descW,descH = bossFontSmall:getWidth( desc ),bossFontSmall:getHeight( desc )
			lg.print( desc, w/2 - descW/2, y + 4)
		end 
	end
end

local targStars = 30
local border = 5 
local starMin = 2
local starMax = 4
local starTable = {}
function game.generateBackground()
	local w,h = love.graphics.getDimensions()
	local r = math.ceil( math.sqrt( targStars ) )
	local c = math.floor( math.sqrt( targStars ) )
	local grid = r*c 
	local gw = w/c 
	local gh = h/r 
	local j = 1 
	for i = 1,grid do 
		local x = gw*(j-1) + love.math.random( border, gw - border )
		local y = math.floor( (i-1)/c )*gh + love.math.random( border, gh - border )
		starTable[ i ] = {x, y, love.math.random( 10, 20 )/100 }
		j = math.loop( j, 1, c )
	end 
end 

function game.drawBackground()
	if game.getState() == "game" then 
		for i = 1,#starTable do 
			local t = starTable[ i ]
			love.graphics.setColor( 255, 255, 255, 255 )
			love.graphics.draw(starImage, t[ 1 ], t[ 2 ], 0, t[ 3 ], t[ 3 ] )
		end
	end 
end 

function game.setScore( num )
	game.__curScore = num 
end 

function game.addScore( num )
	game.setScore( game.getScore() + num )
end 

function game.getScore()
	return game.__curScore
end 

function game.setHighScore( num )

end 

function game.playerDeath()
	local w,h = love.graphics.getDimensions()
	game.endGame = gui.create( "gameOverScreen" )
	game.endGame:setSize( w*0.4, h*0.3 )
	game.endGame:center()	
	game.endGame:createButton()
end 

function game.setWave( n )
	game.__wave = n 
end

function game.getWaveNumber()
	return game.__wave 
end 

function game.getWaveData()
	return WAVE[ game.getWaveNumber() ]
end 

function game.nextWave()
	game.setWave( math.min( game.getWaveNumber() + 1, game.getMaxWave() ) )
end 

function game.getMaxWave()
	return #WAVE - 1
end

function game.shouldSpawn()
	return game.__spawnTime <= love.timer.getTime()
end 

function game.setNextSpawn( t )
	if not t then 
		t = WAVE.delay 
	end 
	game.__spawnTime = love.timer.getTime() + t 
end 

function game.createBullet( tbl )
	local e = ents.create( "bullet_base" )
	e:setBulletData( tbl )
end 