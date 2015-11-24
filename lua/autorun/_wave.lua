
wave = {}
wave.list = {}
wave.className = {}

function wave.add( data, class )
    data.index = #wave.list+1
    if class then 
        local c = wave.className[ class ]
        if not c then 
            wave.className[ class ] = data
        else 
            wave.list[ #wave.list+1 ] = setmetatable( data, { __index = c } ) 
        end 
        return 
    end 
    local c = wave.className[ "wave_base" ] 
    wave.list[ #wave.list+1 ] = setmetatable( data, { __index = c } )
end 

function wave.getIndex()
    return wave._number 
end 

function wave.start()
    local data = wave.getWave()
    data:onStart()
    data:start()
end

function wave.stop()
    local data = wave.getWave()
    data:onFinish()
    data:finish()
end 

function wave.setWave( index )
    local i = math.min( index, #wave.list )
    wave._number = i 
    local newWave = table.copy( wave.list[ i ] )
    wave.__wave = setmetatable( newWave , getmetatable( wave.list[ i ] ) )
end 

function wave.getWave()
    return wave.__wave
end

function wave.think()
    local data = wave.getWave()
    data:think()
    data:spawnThink()
end 

function wave.entityDeath( ent )
    wave.getWave():entityDeath( ent )
end 

function wave.setNextWaveTime( delay )
    local t = love.timer.getTime()
    wave.__nextWaveTime = t + delay 
end 

function wave.getNextWaveTime()
    return wave.__nextWaveTime or 0 
end 
