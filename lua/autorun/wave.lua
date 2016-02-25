
-- Still need to write the actual wave logic. Logic should be done inside the wave itself and not the game.
-- This should allow for much more unique waves, as the wave itself decides when it ends - meaning timers, boss fights, exterminates, etc are all possible.
game.waveList = {}
game.waveOffset = 0 
game.__curWave = 0

function game.addWave( wave, class, base )

    local l = game.waveList 
    if class then 
        wave.id = class 
        l[ wave.id ] = table.copy( wave ) 
        game.waveOffset = game.waveOffset + 1 
    else 
        wave.id = #l - game.waveOffset
        table.insert( l, #l - game.waveOffset, table.copy( wave ) )
    end 

    if base then 
        setmetatable( l[ wave.id ], { __index = l[ base ] } )
    elseif not (class == "wave_base") then
        setmetatable( l[ wave.id ], { __index = l[ "wave_base" ] } )
    end 

    print( wave.id )
    l[ wave.id ]:initInternal()
    l[ wave.id ]:init()

end 

function game.startNextWave()
    
    local data = game.getCurrentWave()
    data:finish()

    local data = game.getCurrentWave()
    if not data.nextWave then 
        game.changeState( "menu" )
    else 
        game.setCurrentWave( data.nextWave )
        data:start()
    end 

end

function game.stopCurrentWave()
    local data = game.getCurrentWave()
    data:finish()
end 

function game.setCurrentWave( id )
    local l = game.waveList 
    game.__curWave = l[ id ]
    game.__curWave:onSet()
end 

function game.getCurrentWave()
    return game.__curWave
end

function game.waveThink()
    local data = game.getCurrentWave()
    data:think()
    data:thinkInternal()
end 

function game.waveEntityDeath( ent )
    game.getCurrentWave():entityDeath( ent )
end 
