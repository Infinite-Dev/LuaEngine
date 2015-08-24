

local lg = love.graphics
local lm = love.mouse

gui = {}
gui.Objects = {} -- Objects that have been created.
gui.Panels = {} -- Panels that have been registered.
gui.cache = {}


--[[----------------------------------------
	gui.Create( base, parent )
	Used to create GUI panels.
--]]----------------------------------------
function gui.Create( base, parent )
	local panel = {}
	local bPanel = gui.Panels[ base ]
	if bPanel then 
		panel = table.Copy( bPanel )
	else 
		uerror( ERROR_GUI, "Invalid panel class specified." )
		return
	end
	
	if parent then
		panel:SetParent( parent )
	end
	
	panel.__children = {}
	panel.__Hovered = false
	panel.__CanClick = false
	panel.__clampDrawing = true
	panel.__x = 0
	panel.__y = 0
	panel.__w = 15
	panel.__h = 5
	
	local pos = #gui.Objects+1 
	panel.__id = pos
	gui.Objects[ pos ] = panel
	panel:_Initialize()
	panel:Init()
	return panel 
end

--[[----------------------------------------
	gui.MergeGUIs( panel, base )
	Use to merge two different defined panels into one.
	Called internally, probably shouildn't be called.
--]]----------------------------------------
function gui.MergeGUIs( panel, base )
	local new_panel = {}
	new_panel = table.Copy( gui.Panels[ base ] )
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
			gui.Register( unpack( gui.cache[ i ] ) )
			gui.cache[ i ] = nil 
		end 
	end 
	if #gui.cache > 0 then
		gui.loadCache()
	end 
end 

--[[----------------------------------------
	gui.Register( name, panel, base )
	Used to add panels to the global table.
--]]----------------------------------------
function gui.Register( name, panel, base )
	if base then
		if not gui.Panels[ base ] then 
			gui.cacheUI( name, panel, base )
		else 
			gui.Panels[ name ] = gui.MergeGUIs( panel, base )
			gui.checkCache( name )
		end 
	else
		gui.Panels[ name ] = panel
		gui.checkCache( name )
	end

	for i = 1,#gui.cache do
		if gui.cache[ i ][ 4 ] then 
			gui.Panels[ gui.cache[ i ][ 1 ] ] = gui.MergeGUIs( gui.cache[ i ][ 2 ], gui.cache[ i ][ 3 ] )
			gui.cache[ i ] = nil 
		end 
	end 
	
end

--Internal.
function gui.Draw()
	for k, panel in pairs( gui.Objects ) do 
		lg.translate( panel.__x, panel.__y )
			if panel.__clampDrawing then 
				lg.setScissor( panel.__x, panel.__y, panel.__w, panel.__h )
			end
			panel:Paint( panel.__w, panel.__h )
			panel:PaintOver( panel.__w, panel.__h )
			lg.setScissor()
		lg.origin()
	end
end

--Internal.
function gui.Update()
	for k, panel in pairs( gui.Objects ) do
		panel:Think()
		panel:__MouseThink()
	end
end


