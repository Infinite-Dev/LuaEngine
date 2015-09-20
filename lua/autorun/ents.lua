
ents = {}
ents._index = {}
ents._list = {}
ents._createList = {}

function Entity( id )
	return ents.getIndex()[ i ]
end 

function ents.create( ent_name )

	local eList = ents.getList()
	local ent = eList[ ent_name ]
	local l = ents.getIndex()

	if ent then 

		local nEnt = table.copy( ent[ 1 ] )
		setmetatable( nEnt, ent[ 2 ] )

		nEnt._index = #l+1
		nEnt._isEntity = true 
		nEnt._class = ent_name 
		nEnt:_initialize()
		nEnt:initialize()
		l[ #l+1 ] = nEnt

		return nEnt

	else 

		uerror( ERROR_ENTIY, "Invalid entity class specified." )
		return nil 

	end

	return nil 

end

function ents.getAll()
	return ents.getIndex()
end

local dist = math.Distance
local p = pairs 
function ents.findInRadius( vec, radius )

	local e = {}

	for k,v in p( ents.getAll() ) do

		local pos = v:getPos()
		if dist( vec.x, vec.y, pos.x, pos.y ) <= radius then
			e[ #e+1 ] = v
		end
		 
	end 

	return e 

end

function ents.getIndex()
	return ents._index
end

function ents.getList()
	return ents._list
end

function ents.think()
	for k,v in p( ents.getAll() ) do
		v:think()
	end 
end 

function ents.draw()
	for k,v in p( ents.getAll() ) do
		--if v:shouldDraw() then
			v:draw()
		--end 
	end 
end 

function ents.registerEntity( name, tbl, base )
	ents.getList()[ name ] = { tbl, (base or _E ) }
end 

function ents.loadEntities( dir )
	dir = dir or "lua/entities"
	local objects = love.filesystem.getDirectoryItems( dir )
	local tbl = {}
	for i = 1,#objects do
		if love.filesystem.isDirectory( dir.."/"..objects[ i ] ) then
			tbl[ #tbl + 1 ] = dir.."/"..objects[ i ]
		else 
			local e = dir.."/"..string.sub( objects[ i ], 0, string.len( objects[ i ] )-4 )
			require( e )
		end
	end
	
	for i = 1,#tbl do
		ents.loadEntities( tbl[ i ] )
	end
end

function isEntity( obj )
	if type( obj ) == "table" then 
		if obj._isEntity then 
			return true 
		end 
	end 
end 

ents.loadEntities()