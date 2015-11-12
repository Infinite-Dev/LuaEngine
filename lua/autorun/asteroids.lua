
asteroids = {}
asteroids.max = 2 
asteroids.minSize = 40
asteroids.maxSize = 60
asteroids.gibminSize = 1
asteroids.gibmaxSize = 3
asteroids.speed = 100
asteroids.health = 1 
asteroids.delay = 5
asteroids.lastDelayTime = 0 
asteroids.playerHealth = 100

local posFuncs =
{
	function( r )
		local w,h = love.graphics.getDimensions()
		local x = love.math.random( 0, w )
		local y = -r*1.1
		return x,y
	end, 	
	function( r )
		local w,h = love.graphics.getDimensions()
		local x = love.math.random( 0, w )
		local y = h + r*1.1
		return x,y
	end, 	
	function( r )
		local w,h = love.graphics.getDimensions()
		local x = -r*1.1
		local y = love.math.random( 0, h )
		return x,y  
	end, 	
	function( r )
		local w,h = love.graphics.getDimensions()
		local x = w + r*1.1
		local y = love.math.random( 0, h )
		return x,y 
	end
}
function asteroids.createNewAsteroid()

	local ast = ents.create( "ent_asteroid" )
	ast:generate()

	local w,h = love.graphics.getDimensions()
	local x, y = posFuncs[ love.math.random( 1, 4 ) ]( ast.r )

	ast:setPos( x, y )

	local vec1 = Vector( x, y )
	local vec2 = Vector( w/2, h/2 )

	local norm = ( vec2 - vec1 ):normalized()*ast.r*asteroids.speed

	ast:move( norm )

end 