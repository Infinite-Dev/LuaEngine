
wave = {}
wave.list = {}

function wave.register( index, data )
    wave.list[ index ] = data 
end 

function wave.getIndex()
    return wave.__index 
end 

function wave.start()
    local index = wave.getIndex()
    local data = wave.getWave()
    wave.setWaveThinkFunction( data.think )
    data:onFinish()
end

function wave.stop()
    local data = wave.getWave()
    data:onFinish()
end 

function wave.setWave( index )
    wave.__index = index 
    wave.__wave = wave.list[ index ] 
end 

function wave.getWave()
  return wave.__wave
end

function wave.setWaveThinkFunction( func )
    wave.__thinkFunc = func 
end 

function wave.getWaveThinkFunction()
    return wave.__thinkFunc 
end 

function wave.think()
    wave.getWaveThinkFunction()
end 