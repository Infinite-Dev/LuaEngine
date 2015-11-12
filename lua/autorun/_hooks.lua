
hook = {} -- Define our hook table.
hook.list = {} -- The list of hooks.

--[[----------------------------------------
	hook.add( name, id, func )
	Used to add hooks, which are run when
	hook.call is run with the same name.
--]]----------------------------------------

function hook.add( name, id, func )
	if not hook.list[ name ] then
		hook.list[ name ] = {}
		hook.list[ name ][ id ] = func
	else
		hook.list[ name ][ id ] = func
	end
end

--[[----------------------------------------
	hook.call( name, args )
	Used to call all the hooks under that name.
--]]----------------------------------------

function hook.call( name, ... )
	local h_tbl = hook.list[ name ]
	if h_tbl then
		for k,v in pairs( h_tbl ) do
			v( unpack( arg ) )
		end
	end
end

--[[----------------------------------------
	hook.remove( name, id )
	Used to remove hooks.
--]]----------------------------------------

function hook.remove( name, id )
	if hook.list[ name ] then 
		hook.list[ name ][ id ] = nil
	end 
end