
hook = {} -- Define our hook table.
hook.List = {} -- The list of hooks.

--[[----------------------------------------
	hook.Add( name, id, func )
	Used to add hooks, which are run when
	hook.Call is run with the same name.
--]]----------------------------------------

function hook.Add( name, id, func )
	if not hook.List[ name ] then
		hook.List[ name ] = {}
		hook.List[ name ][ id ] = func
	else
		hook.List[ name ][ id ] = func
	end
end

--[[----------------------------------------
	hook.Call( name, args )
	Used to call all the hooks under that name.
--]]----------------------------------------

function hook.Call( name, ... )
	local h_tbl = hook.List[ name ]
	if h_tbl then
		for k,v in pairs( h_tbl ) do
			v( unpack( arg ) )
		end
	end
end

--[[----------------------------------------
	hook.Remove( name, id )
	Used to remove hooks.
--]]----------------------------------------

function hook.Remove( name, id )
	hook.List[ name ][ id ] = nil
end