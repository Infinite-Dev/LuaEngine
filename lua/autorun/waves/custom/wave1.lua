
local WAVE      = {}
WAVE.printName  = "Wave 1"
WAVE.desc       = "Easy peasy."
WAVE.duration   = 15
WAVE.spawnList  =
{
    [ "npc_droneboss" ] = { 1, 1 }
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

game.addWave( WAVE, 1, "wave_time_base" )
