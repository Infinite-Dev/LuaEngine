
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

    l[ wave.id ]:initializeInternal()
    l[ wave.id ]:initialize()

end

function game.startNextWave()

    local data = game.getCurrentWave()

    game.stopCurrentWave()

    if not data.nextWave then
        game.changeState( "menu" )
    else
        game.setCurrentWave( data.nextWave )
        local data = game.getCurrentWave()
        data:start()
        data:onStart()
        data:setInProgress( true )
    end

end

function game.stopCurrentWave()
    local data = game.getCurrentWave()
    data:finish()
    data:onFinish()
    data:setInProgress( false )
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
    if data:inProgress() and data:canEnd() then
      game.startNextWave()
    end
end

function game.waveEntityDeath( ent )
    game.getCurrentWave():entityDeathInternal( ent )
    game.getCurrentWave():entityDeath( ent )
end
