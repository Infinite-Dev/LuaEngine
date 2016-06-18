
local WAVE      = {}
WAVE.printName  = "Wave 1"
WAVE.desc       = "Easy peasy."
WAVE.duration   = 60
WAVE.nextWave   = 2
WAVE.spawnList  =
{
    [ "ent_gravity" ] = 1
}
WAVE.spawnWaveDelay = 2

function WAVE:onSet()
end

function WAVE:onStart()
end

function WAVE:onFinish()
end

function WAVE:finish()
end

function WAVE:think()
end

function WAVE:entityDeath( ent )
end

function WAVE:onSpawn( ent )
    local w, h = love.graphics.getDimensions()
    ent:setPos( w/2, h/2 )
    ent:setSize( 30 )
    ent:setMass( 5000^3.8 )
end
game.addWave( WAVE, 1, "wave_time_base" )

local WAVE      = {}
WAVE.printName  = "Wave 2"
WAVE.desc       = "Easy peasy. MKII"
WAVE.duration   = 3
WAVE.spawnList  =
{
    [ "npc_ufo" ] = 3
}
WAVE.spawnWaveDelay = 2


function WAVE:onSet()
end

function WAVE:onStart()
end

function WAVE:onFinish()
end

function WAVE:finish()
end

function WAVE:think()
end

function WAVE:entityDeath( ent )
end

game.addWave( WAVE, 2, "wave_time_base" )
