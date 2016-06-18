
local WAVE      = {}
WAVE.printName  = "Base Wave - return of the cock up"
WAVE.desc       = "The fuck are you doing?"
WAVE.duration   = 15
WAVE.spawnList  =
{
    [ "ent_asteroid" ] = 1
}
WAVE.spawnWaveDelay = 2

function WAVE:initializeInternal()
    self.__spawnWaves = {}
    self.__lastSpawnTime = 0
    self.__waveEntities = {}
end

function WAVE:initialize()
end

function WAVE:onSet()
end

function WAVE:onStart()
end

function WAVE:start()
    self:setEndTime( love.timer.getTime() + self.duration )
    for k,data in pairs( self.spawnList ) do
        if type( data ) == "table" then
            self:addSpawnWave( data, k, love.timer.getTime()-self.spawnWaveDelay )
        else
            for i = 1,data do
                self:spawn( k )
            end
        end
    end
end

function WAVE:onSpawn( ent )
    local pos = ent:getPos()
    print( pos )
    local centre = vector( love.graphics.getWidth()/2, love.graphics.getHeight()/2 )
    local norm = ( centre - pos ):normalized()
    ent:setVelocity( norm*200 )
end

function WAVE:spawn( class )
    local ent = ents.create( class )
    ent:setPos( ( ent.getSpawnPos and ent:getSpawnPos()) or self:getEntitySpawnPos( ent ) )
    self:onSpawn( ent )
    self:addWaveEntity( ent )
end

function WAVE:getWaveEntities()
    return self.__waveEntities
end

function WAVE:addWaveEntity( ent )
    table.insert( self:getWaveEntities(), ent:getID(), ent )
end

function WAVE:getSpawnWaves()
    return self.__spawnWaves
end

function WAVE:getLastSpawnTime()
    return self.__lastSpawnTime
end

function WAVE:getSpawnList()
    return self.spawnList
end

function WAVE:addSpawnWave( data, class, baseTime )
    for k,enemyNum in pairs( data ) do
        local t = love.timer.getTime()
        baseTime = baseTime or t
        local tbl = { class = class, num = enemyNum, start = baseTime + self.spawnWaveDelay*k  }
        table.insert( self:getSpawnWaves(), tbl )
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

function WAVE:entityDeathInternal( ent )
    local l = self:getWaveEntities()
    if l[ ent:getID() ] then
        print( ent:getClass() )
        table.remove( l, ent:getID() )
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
    local b = love.timer.getTime() > self:getEndTime()
    local enemyList = self:getWaveEntities()
    local a = (#enemyList == 0)
    if a and b then
        print( "change noaww!" )
    end
    return a and b
end

function WAVE:getTotalSpawnCount()
  local list = self:getSpawnList()
  local count = 0
  for k,v in pairs( list ) do
    if type( v ) == "table" then
      for i = 1,#v do
        count = count + v[ i ]
      end
    else
      count = count + v
    end
  end
end

game.addWave( WAVE, "wave_time_base" )
