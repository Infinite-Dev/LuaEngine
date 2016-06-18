
ents = {}
ents._index = {}
ents._list = {}
ents._createList = {}
ents.cache = {}
ents.deathList = {}
ents.removeList = {}

function entity( id )
	return ents.getIndex()[ id ]
end

local entID = 1
function ents.create( ent_name )

	local eList = ents.getList()
	local ent = eList[ ent_name ]
	local l = ents.getIndex()

	if ent then

		local mTable = ent.__metaTable
		local nEnt = setmetatable( table.copy( ent ), mTable )
		nEnt._index = #l+1
		nEnt._id 	= entID
		nEnt._isEntity = true
		nEnt._class = ent_name
		nEnt:_initialize()
		nEnt:initialize()
		l[ #l+1 ] = nEnt

		game.onEntCreated( ent )

		entID = entID + 1 

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

function ents.addToDeathList( ent )
	ents.deathList[ #ents.deathList+1 ] = ent
end

function ents.addToRemoveList( ent )
	ents.removeList[ #ents.removeList+1 ] = ent
end

function ents.think()
	ents.cleanUp()
	for k,v in p( ents.getAll() ) do
		v:think()
	end
end

function ents.cleanUp()
	local list = ents.deathList
	for i = 1,#list do
		local ent = list[ i ]
		game.entityDeath( ent )
		ent:onDeath()
	end
	ents.deathList = {}
end

function ents.draw( t )
	for k,v in p( ents.getAll() ) do
		if v:shouldDraw() then
			v:draw( t )
		end
	end
end

function ents.registerEntity( name, tbl, base )

	tbl._class = name
	local list = ents.getList()
	if base then
		if not list[ base ] then
			ents.cacheEnt( name, tbl, base )
		else
			local baseEnt = list[ base ]
			baseEnt.__index = baseEnt
			local tbl = setmetatable( tbl, baseEnt )
			tbl.__metaTable = baseEnt
			list[ name ] = tbl
			ents.checkCache( name )
		end
	else
		tbl.__index = _E
		tbl.__metaTable = _E
		list[ name ] = setmetatable( tbl, _E )
		ents.checkCache( name )
	end

	for i = 1,#ents.cache do
		if ents.cache[ i ][ 4 ] then
			ents.registerEntity( unpack( ents.cache[ i ] ) )
			ents.cache[ i ] = nil
		end
	end

end

function ents.cacheEnt( name, tbl, base, bValidBase )
	ents.cache[ #ents.cache +1 ] = { name, tbl, base, bValidBase }
end

function ents.checkCache( name )
	if #ents.cache > 0 then
		for i = 1,#ents.cache do
			if ents.cache[ i ][ 3 ] == name then
				ents.cache[ i ][ 4 ] = true
			end
		end
	end
end

function ents.loadCache()
	for i = 1,#ents.cache do
		if ents.cache[ i ][ 4 ] then
			ents.register( unpack( ents.cache[ i ] ) )
			ents.cache[ i ] = nil
		end
	end
	if #ents.cache > 0 then
		ents.loadCache()
	end
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
