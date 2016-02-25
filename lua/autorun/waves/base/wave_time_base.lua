
local WAVE      = {}
WAVE.printName  = "Base Wave - return of the cock up"
WAVE.desc       = "The fuck are you doing?"
WAVE.duration   = 15
WAVE.spawnList  = 
{
    [ "ent_asteroid" ] = 2
}
WAVE.spawnWaveDelay = 2
WAVE.__spawnWaves = {}
WAVE.__lastSpawnTime = 0

function WAVE:onSet()
end 

function WAVE:onStart()
end 

function WAVE:start()
    self:setEndTime( love.timer.getTime() + self.duration )
    for k,data in pairs( self.spawnList ) do 
        if type( data ) == "table" then 
            self:addSpawnWave( data, k, love.timer.getTime()-2 )
        else 
            for i = 1,data do 
                self:spawn( k )
            end 
        end 
    end  
end 

function WAVE:spawn( class )
    local ent = ents.create( class )
    ent:setPos( ent:getSpawnPos() )
end 

function WAVE:getSpawnWaves()
    return self.__spawnWaves
end 

function WAVE:getLastSpawnTime()
    return self.__lastSpawnTime
end 

function WAVE:addSpawnWave( data, class, baseTime )
    for k,enemyNum in pairs( data ) do 
        local t = love.timer.getTime()
        baseTime = baseTime or t 
        local tbl = { class = class, num = enemyNum, start = baseTime + self.spawnWaveDelay*k  }
        table.insert( self.__spawnWaves, tbl )
    end 
end 

function WAVE:onFinish()
end 

function WAVE:finish()
end 

function WAVE:think()
end 

function WAVE:thinkInternal()
    local t = love.timer.getTime()
    local waves = self:getSpawnWaves()
    for k,wave in pairs( waves ) do 
        if wave.start <= t then 
            for i = 1,wave.num do 
                self:spawn( wave.class )
            end 
            table.remove( waves, k )
        end 
    end 
end 

function WAVE:entityDeath( ent )
end 

function WAVE:setEndTime( t )
    self.endTime = t 
end 

function WAVE:getEndTime()
    return self.endTime 
end 

function WAVE:canEnd()
    return love.timer.getTime() > self:getEndTime()
end 

game.addWave( WAVE, "wave_time_base" )