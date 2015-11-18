
WAVE =
{
  [ 1 ]  = { {1, "npc_droneboss" }, {1, "ent_asteroid"} },
  [ 2 ]  = { {2, "npc_drone" } },
  [ 3 ]  = { {2, "npc_drone" } },
  [ 4 ]  = { {2, "ent_asteroid" } },
  [ 5 ]  = { {2, "ent_asteroid" } },
  [ 6 ]  = { {3, "ent_asteroid" } },
  [ 7 ]  = { {3, "ent_asteroid" } },
  [ 8 ]  = { {3, "ent_asteroid" } },
  [ 9 ]  = { {3, "ent_asteroid" } },
  [ 10 ] = { {3, "ent_asteroid" } },
  [ 11 ] = { {4, "ent_asteroid" } },
  [ 12 ] = { {4, "ent_asteroid" } },
  [ 13 ] = { {4, "ent_asteroid" } },
  [ 14 ] = { {4, "ent_asteroid" } },
  [ 15 ] = { {4, "ent_asteroid" } },
  [ 16 ] = { {4, "ent_asteroid" } },
  [ 17 ] = { {4, "ent_asteroid" } },
  [ 18 ] = { {4, "ent_asteroid" } },
  [ 19 ] = { {4, "ent_asteroid" } },
  [ 20 ] = { {4, "ent_asteroid" } }
}
WAVE.delay = 12

local defaultWaveData = {}
defaultWaveData.duration   = 12 
defaultWaveData.score      = 100 
defaultWaveData.spawns =
{
    [ "npc_drone" ] = 1,
    [ "ent_asteroid" ] = 2
}

local WAVE = {}
function WAVE:initialize()
    self:setWaveData( defaultWaveData )
end 

function WAVE:onStart()

end

function WAVE:onFinish()

end 

function WAVE:think()

end 

function WAVE:setWaveData( data )
    self.__waveData = data 
end 

function WAVE:getWaveData()
    return self.__waveData 
end 

function WAVE:setSpawnList( spawns )
    self:getWaveData().spawns = spawns 
end 

function WAVE:getSpawnList()
    return self:getWaveData().spawns 
end 

function WAVE:spawnThink()

end 

function WAVE:spawn()
    local spawns = self:getSpawnList()
    for i = 1,#spawns do 

    end 
end 

function WAVE:setScoreValue( score )
    self.__score = score 
end 

function WAVE:getScoreValue()
    return self.__score 
end 

function WAVE:setDuration( t )
    self:getWaveData().duration = t 
end 

function WAVE:getDuration()
    return self:getWaveData().duration 
end 

function WAVE:enemyDeath( enemy )
    if enemy.isWaveEnemy then 
                
    end 
    self:onEnemyDeath()
end 

function WAVE:canEnd()

end

