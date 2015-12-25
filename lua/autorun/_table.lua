
--[[----------------------------------------
	table.copy( table )
	Used to create a new instance of a table.
--]]----------------------------------------

local function istable( t )
    return type( t ) == "table"
end 
function table.copy( t, lookup_table )
    if ( t == nil ) then return nil end

    local copy = {}
    setmetatable( copy, debug.getmetatable( t ) )
    for i, v in pairs( t ) do
        if ( not istable( v ) ) then
            copy[ i ] = v
        else
            lookup_table = lookup_table or {}
            lookup_table[ t ] = copy
            if ( lookup_table[ v ] ) then
                copy[ i ] = lookup_table[ v ] -- we already copied this table. reuse the copy.
            else
                copy[ i ] = table.copy( v, lookup_table ) -- not yet copied. copy it.
            end
        end
    end
    return copy
end 

function table.merge( dest, source )

    for k, v in pairs( source ) do
        if ( type( v ) == "table" and type( dest[ k ] ) == "table" ) then
            -- don't overwrite one table with another
            -- instead merge them recurisvely
            table.merge( dest[ k ], v )
        else
            dest[ k ] = v
        end
    end

    return dest

end


function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end