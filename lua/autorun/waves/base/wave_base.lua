
local WAVE      = {}
WAVE.printName  = "Base Wave - return of the cock up"
WAVE.desc       = "The fuck are you doing?"

function WAVE:initInternal()
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

game.addWave( WAVE, "wave_base" )