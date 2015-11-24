local WAVE = {}
local waveData = {}
waveData.duration    = 10
waveData.score       = 100 
waveData.waveDelay   = 2  
waveData.spawns =
{
    [ "npc_ufo" ] = 3
}
WAVE.__waveData = waveData 

wave.add( WAVE )

local WAVE = {}
local waveData = {}
waveData.duration    = 10
waveData.score       = 100 
waveData.waveDelay   = 5 
waveData.spawns =
{
    [ "npc_drone" ] = { 4, 4 }
}
WAVE.__waveData = waveData 

wave.add( WAVE )

local WAVE = {}
local waveData = {}
waveData.duration    = 10
waveData.score       = 100 
waveData.waveDelay   = 5  
waveData.spawns =
{
    [ "npc_drone" ] = { 5, 5 }
}
WAVE.__waveData = waveData 

wave.add( WAVE )

local WAVE = {}
local waveData = {}
waveData.duration    = 15
waveData.score       = 100 
waveData.waveDelay   = 2  
waveData.spawns =
{
    [ "npc_drone" ]     = 3,
    [ "ent_asteroid" ]  = 2
}
WAVE.__waveData = waveData 

wave.add( WAVE )

local WAVE = {}
local waveData = {}
waveData.duration    = 15
waveData.score       = 100 
waveData.waveDelay   = 2  
waveData.spawns =
{
    [ "npc_drone" ]     = 3,
    [ "npc_droneboss" ]  = 1
}
WAVE.__waveData = waveData 

wave.add( WAVE )