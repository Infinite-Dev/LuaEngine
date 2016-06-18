
local WAVE      = {}
WAVE.printName  = "Base Wave - return of the cock up"
WAVE.desc       = "The fuck are you doing?"

function WAVE:initializeInternal()
end

function WAVE:initialize()
end

function WAVE:onSet()
end

function WAVE:onStart()
end

function WAVE:start()
end

function WAVE:onFinish()
end

function WAVE:finish()
end

function WAVE:think()
end

function WAVE:thinkInternal()
end

function WAVE:entityDeath( ent )
end

function WAVE:canEnd()
    return true
end

function WAVE:setInProgress( b )
  self._inProgress = b
end

function WAVE:inProgress()
  return self._inProgress
end

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
function WAVE:getEntitySpawnPos( ent )
  local rand = math.random( 1, 4 )
  return posFuncs[ rand ]( ent:getSize() or 10 )
end

game.addWave( WAVE, "wave_base" )
