
local defaultWaveData = {}
defaultWaveData.duration    = 1
defaultWaveData.score       = 100 
defaultWaveData.waveDelay   = 2  
defaultWaveData.spawns =
{
    [ "npc_drone" ] = 1
}

local WAVE = {}
WAVE.__waveData = defaultWaveData 

function WAVE:initialize()
end 

function WAVE:onStart()
end

function WAVE:onFinish()
end 

function WAVE:think()
end 

function WAVE:setWaveData( data )
    self:setDuration( data.duration )
    self.__waveData = data
    local n = 0 
    local spawns = data.spawns 
    for k,v in pairs( spawns ) do 
        if type( v ) == "table" then 
            for i2 = 1,#v do 
                n = n + v[ i2 ]
            end 
        else 
            n = n + v 
        end 
    end  
    self:setTotalEnts( n )
end 

function WAVE:getWaveData()
    return self.__waveData 
end 

function WAVE:setDuration( t )
   self.__time = love.timer.getTime() + t 
end 

function WAVE:getDuration()
    return self.__time 
end 

function WAVE:setSpawns( spawns )
    self:getWaveData().spawns = spawns 
end 

function WAVE:getSpawns()
    return self:getWaveData().spawns 
end 

function WAVE:getSpawnList()
    return self.spawnList or {}
end

function WAVE:setSpawnWave( n )
    self.spawnWave = n 
end

function WAVE:getSpawnWave()
    return self.spawnWave 
end 

function WAVE:setNextSpawnWave( delay )
    local t = love.timer.getTime() 
    self.nextSpawnWave = t + delay 
end 

function WAVE:getNextSpawnWave()
    return self.nextSpawnWave or 0 
end 

function WAVE:shouldSpawnNewWave()
    return love.timer.getTime() >= self:getNextSpawnWave()
end 

function WAVE:spawnThink()
    if self:shouldSpawnNewWave() then 
        local list = self:getSpawnList()
        local n = self:getSpawnWave()
        if n > #list then return end 
        for i = 1,#list[ n ] do 
            for i2 = 1,list[ n ][ i ][ 2 ] do 
                self:spawn( list[ n ][ i ][ 1 ], 1 )
            end 
        end 
        self:setSpawnWave( n + 1 )
        self:setNextSpawnWave( self:getWaveData().waveDelay )
    end 
end 

function WAVE:addToSpawnList( class, data ) 
    for i = 1,#data do 
        if not self.spawnList[ i ] then 
            self.spawnList[ i ] = {}
        end 
        table.insert( self.spawnList[ i ], { class, data[ i ] } )
    end 
end 

function WAVE:start()
    self:reset()
    local spawns = self:getSpawns()
    for k,v in pairs( spawns ) do 
        if type( v ) == "table" then 
            self:addToSpawnList( k, v )
        else
            self:spawn( k, v )
        end 
    end 
    self.active = true 
end 

function WAVE:finish()
    self:reset()
    self.active = false 
end

function WAVE:spawn( class, n )
    for i = 1,n do 
        local ent = ents.create( class )
        ent:setPos( ent:getSpawnPosition() )
        ent.isWaveEnemy = true
        ent:onSpawn()
        self:onSpawn( ent )
    end 
end 

function WAVE:onSpawn( ent )
end 

function WAVE:setScoreValue( score )
    self.__score = score 
end 

function WAVE:getScoreValue()
    return self.__score 
end 

function WAVE:setDuration( t )
    self.__time = love.timer.getTime() + t 
end 

function WAVE:getDuration()
    return self.__time 
end 

function WAVE:entityDeath( enemy )
    if enemy.isWaveEnemy then 
        self:addEntityDeath( enemy )        
    end 
    self:onEntityDeath( enemy )
end 

function WAVE:onEntityDeath()
end 

function WAVE:addEntityDeath( enemy )
    self.__entityDeaths = (self.__entityDeaths or 0 ) +  1
end 

function WAVE:setEntityDeaths( n )
    self.__entityDeaths = n 
end 

function WAVE:getEntityDeaths()
    return self.__entityDeaths or 0 
end 

function WAVE:getTotalEnts()
    return self.__totalEnts
end 

function WAVE:setTotalEnts( n )
    self.__totalEnts = n 
end

function WAVE:canEnd()
    local deaths = self:getEntityDeaths()
    local entCount = self:getTotalEnts()
    local entCheck = deaths == entCount 
    local timeCheck = love.timer.getTime() > self:getDuration()
    local canEnd = entCheck and timeCheck
    return canEnd 
end

function WAVE:getIndex()
    return self.index 
end 

function WAVE:inProgress()
    return self.active or false 
end

function WAVE:reset()

    self.spawnList = {}
    self:setWaveData( self.__waveData )
    self:setSpawnWave( 1 )
    self:setEntityDeaths( 0 )
    self:setNextSpawnWave( 0 )

end 

function WAVE:getBossHealthPos()
    
end 

wave.add( WAVE, "wave_base" )

