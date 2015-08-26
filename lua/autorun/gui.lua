

local lg = love.graphics
local lm = love.mouse

gui = {}
gui.objects = {} -- Objects that have been created.
gui.panels = {} -- Panels that have been registered.
gui.cache = {}


--[[----------------------------------------
	gui.create( base, parent )
	Used to create GUI panels.
--]]----------------------------------------
function gui.create( base, parent )
	local panel = {}
	local bPanel = gui.panels[ base ]
	if bPanel then 
		panel = table.copy( bPanel )
	else 
		uerror( ERROR_GUI, "Invalid panel class specified." )
		return
	end
	
	if parent then
		panel:setParent( parent )
	end
	
	panel.__children = {}
	panel.__hovered = false
	panel.__canClick = false
	panel.__clampDrawing = true
	panel.__x = 0
	panel.__y = 0
	panel.__w = 15
	panel.__h = 5
	
	local pos = #gui.objects+1 
	panel.__id = pos
	gui.objects[ pos ] = panel
	panel:_initialize()
	panel:init()
	return panel 
end

--[[----------------------------------------
	gui.mergeGUIs( panel, base )
	Use to merge two different defined panels into one.
	Called internally, probably shouildn't be called.
--]]----------------------------------------
function gui.mergeGUIs( panel, base )
	local new_panel = {}
	new_panel = table.copy( gui.panels[ base ] )
	for k,v in pairs( panel ) do
		new_panel[ k ] = v
	end
return new_panel
end

function gui.cacheUI( name, panel, base, bValidBase )
	gui.cache[ #gui.cache +1 ] = { name, panel, base, bValidBase or false }
end 

function gui.checkCache( name )
	if #gui.cache > 0 then
		for i = 1,#gui.cache do
			if gui.cache[ i ][ 3 ] == name then 
				gui.cache[ i ][ 4 ] = true 
			end 
		end 
	end 
end 

function gui.loadCache()
	for i = 1,#gui.cache do
		if gui.cache[ i ][ 4 ] then
			gui.register( unpack( gui.cache[ i ] ) )
			gui.cache[ i ] = nil 
		end 
	end 
	if #gui.cache > 0 then
		gui.loadCache()
	end 
end 

--[[----------------------------------------
	gui.register( name, panel, base )
	Used to add panels to the global table.
--]]----------------------------------------
function gui.register( name, panel, base )
	if base then
		if not gui.panels[ base ] then 
			gui.cacheUI( name, panel, base )
		else 
			gui.panels[ name ] = gui.mergeGUIs( panel, base )
			gui.checkCache( name )
		end 
	else
		gui.panels[ name ] = panel
		gui.checkCache( name )
	end

	for i = 1,#gui.cache do
		if gui.cache[ i ][ 4 ] then 
			gui.panels[ gui.cache[ i ][ 1 ] ] = gui.mergeGUIs( gui.cache[ i ][ 2 ], gui.cache[ i ][ 3 ] )
			gui.cache[ i ] = nil 
		end 
	end 
	
end

--Internal.
function gui.draw()
	for k, panel in pairs( gui.objects ) do 
		lg.translate( panel.__x, panel.__y )
			if panel.__clampDrawing then 
				lg.setScissor( panel.__x, panel.__y, panel.__w, panel.__h )
			end
			panel:paint( panel.__w, panel.__h )
			panel:paintOver( panel.__w, panel.__h )
			lg.setScissor()
		lg.origin()
	end
end

--Internal.
function gui.update()
	for k, panel in pairs( gui.objects ) do
		panel:think()
		panel:__mouseThink()
	end
end


