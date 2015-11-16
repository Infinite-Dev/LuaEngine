
npc = {}

function npc.getAll() 
	local npcs = {}
	local ents = ents.getAll()
	for k,e in pairs( ents ) do 
		if e:isNPC() then 
			npcs[ #npcs+1 ] = e
		end 
	end
	return npcs  
end 