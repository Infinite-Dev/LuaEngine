
ents = {}
ents.__Index = {}
ents.__List = {}

function Entity( id )
	return ents.GetIndex()[ i ]
end 

function ents.Create( ent_name )

	local eList = ents.GetList()
	local ent = eList[ ent_name ]
	local l = ents.GetIndex()

	if ent then 

		local nEnt = table.Copy( ent )

		if nEnt.Base then 

			if eList[ nEnt.Base ] then

			 	setmetatable( nEnt, eList[ nEnt.Base ] )

			else

				uerror( ERROR_ENTIY, "Invalid entity base specified, expect errors!" )
			
			end 

		end 

		nEnt.__Index = #l+1
		l[ #l+1 ] = nEnt

		return nEnt

	else 

		uerror( ERROR_ENTIY, "Invalid entity class specified." )
		return nil 

	end

	return nil 

end

function ents.GetAll()
	return ents.GetIndex()
end

local dist = math.Distance
local p = pairs 
function ents.FindInRadius( vec, radius )

	local e = {}

	for k,v in p( ents.GetAll() ) do

		local pos = v:GetPos()
		if dist( vec.x, vec.y, pos.x, pos.y ) <= radius then
			e[ #e+1 ] = v
		end
		 
	end 

	return e 

end

function ents.GetIndex()
	return ents.__Index
end

function ents.GetList()
	return ents.__List
end

function ents.Think()
	for k,v in p( ents.GetAll() ) do
		v:Think()
	end 
end 

function ents.Draw()
	for k,v in p( ents.GetAll() ) do
		if v:ShouldDraw() then
			v:Draw()
		end 
	end 
end 

function ents.RegisterEntity( name, tbl, base )
	local tbl = setmetatable( tbl, base or _E )
	ents.GetList()[ name ] = tbl
end 

function ents.LoadEntities( dir )
	dir = dir or "lua/entities"
	local objects = love.filesystem.getDirectoryItems( dir )
	local tbl = {}
	for i = 1,#objects do
		if love.filesystem.isDirectory( dir.."/"..objects[ i ] ) then
			tbl[ #tbl + 1 ] = dir.."/"..objects[ i ]
		else 
			local e = dir.."/"..string.sub( objects[ i ], 0, string.len( objects[ i ] ) )
			local ok, chunk, result
			ok, chunk = pcall( love.filesystem.load,  e )
			print( e )
			if ok then 
				chunk()
			end 
		end
	end
	
	for i = 1,#tbl do
		ents.LoadEntities( tbl[ i ] )
	end
end
