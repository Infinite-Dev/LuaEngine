

local lg = love.graphics
local lm = love.mouse

gui = {}
gui.objects = {} -- Objects that have been created.
gui.panels 	= {} -- Panels that have been registered.
gui.cache 	= {}
gui._maxz 	= 0
gui._minz 	= 0
gui.pos 	= 0

--[[----------------------------------------
	gui.create( base, parent )
	Used to create GUI panels.
--]]----------------------------------------
function gui.create( class, parent )
	local panel = {}
	local bPanel = gui.panels[ class ]
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
	panel.__hovered = false -- Is the panel being hovered over by the mouse?
	panel.__canClick = false -- Can the panel be clicked?
	panel.__clampDrawing = true -- Should we limit drawing to the x,y/w,h of the panel?
	panel.__childClick = false -- Can we click on child objects if they are outside the panels boundaries?
	panel.__x = 0
	panel.__y = 0
	panel.__w = 15
	panel.__h = 5
	panel.__class = class

	gui.pos = gui.pos + 1
	local pos = gui.pos
	panel.__id = pos
	table.insert( gui.objects, panel )

	panel:setZ( gui.getMaxZ() + 1 )
	panel:_initialize()
	panel:initialize()
	gui.generateDrawOrder()
	return panel
end

--[[----------------------------------------
	gui.mergeGUIs( panel, base )
	Use to merge two different defined panels into one.
	Called internally, probably shouildn't be called.
--]]----------------------------------------
function gui.mergeGUIs( panel, base )
	local new_panel = {}
	new_panel = table.merge( table.copy( gui.panels[ base ] ), panel )
	new_panel.baseClass = table.copy( gui.panels[ base ] )
	return new_panel
end

function gui.cacheUI( name, panel, base, bValidBase )
	gui.cache[ #gui.cache +1 ] = { name, panel, base, bValidBase }
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

function gui.getMaxZ()
	return gui._maxz
end

function gui.setMaxZ( num )
	gui._maxz = num
end

function gui.getMinZ()
	return gui._minz
end

function gui.setMinZ( num )
	gui._minz = num
end

function gui.setModal( pnl )
	gui.__modal = pnl
end

function gui.getModal()
	return gui.__modal
end

function gui.getObjects()
	return gui.objects
end

function gui.generateDrawOrder()
	local list = gui.getObjects()
	table.sort( list, function( t, t2 )
		return ( t:getZ() < t2:getZ() or false )
	end )
end

local function findDrawClips( parent, x, y, w, h )
	while parent do
		local px, py = parent:getPos()
		local pw, ph = parent:getSize()
		local oldx, oldy = x, y
		local oldw, oldh = w, h
		if parent.__clampDrawing then

			if px > x then
				x = math.min( px, ( x + w ) )
				w = oldx + w - x
			end

			if x + w > px + pw then
					local dif = px + pw - (x + w)
					w = math.max( 0, w + dif )
			end

			if py > y then
				y = math.min( py, ( y + h ) )
				h = oldy + h - y
			end

			if y + h > py + ph then
				local dif = py + ph - (y + h)
				h = math.max( 0, h + dif )
			end

		end
		parent = parent:getParent()
	end
	return x, y, w, h
end

--Internal.
function gui.draw()

	local tbl = gui.getObjects()
	for i = 1,#tbl do

		local panel = tbl[ i ]
		local w,h = panel:getSize()
		local x,y = panel:getPos()

		local transx, transy = x, y

		local parent = panel:getParent()
		local clipx, clipy, clipw, cliph = findDrawClips( parent, x, y, w, h )

		local paintw,painth = w,h

		lg.translate( transx, transy )
		--	if panel.__clampDrawing then
				lg.setScissor( clipx, clipy, clipw, cliph )
		--	end
			panel:paint( paintw, painth )
			panel:paintOver( paintw, painth )
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

--[[----------------------------------------
	Check to see if we clicked on a gui panel.
	Should probably make this less shit.
--]]----------------------------------------

function gui.buttonCheck( x, y, button, istouch )
	local in_area = util.isInArea
	local p = gui.getModal()
	if p then
		local tbl = { p, unpack( p:getChildren() ) }
		local pnls = {}
		for k,v in pairs( tbl ) do
			local p_x,p_y = v:getPos()
			local p_w,p_h = v:getSize()
			if in_area( x, y, p_x, p_y, p_w, p_h ) then
				pnls[ #pnls + 1 ] = v
			end
		end

		local z = -math.huge
		local targ = nil
		for i = 1,#pnls do
			local p2 = pnls[ i ]
			if p2:getZ() >= z then
				z = p2:getZ()
				targ = p2
			end
		end

		if targ then
			if targ:canClick() then
				targ:__click( button )
				gui.curButton = targ
			end
			if not targ:isChild() then
				targ:bringToFront()
			end
		end
		return
	end

	local tbl = {}
	for k, panel in pairs( gui.objects ) do
		local p_x,p_y = panel:getPos()
		local p_w,p_h = panel:getSize()
		local prnt = panel:getParent()
		if prnt and prnt:getRestrictChildClick() then
			local prntx, prnty = prnt:getPos()
			local prntw, prnth = prnt:getSize()
			if in_area( x, y, p_x, p_y, p_w, p_h ) and in_area( x, y, prntx, prnty, prntw, prnth ) then
				tbl[ #tbl + 1 ] = panel
			end
		elseif in_area( x, y, p_x, p_y, p_w, p_h ) then
			tbl[ #tbl + 1 ] = panel
		end
	end

	local z = -math.huge
	local p = nil
	for i = 1,#tbl do
		local pnl = tbl[ i ]
		if pnl:getZ() >= z then
				z = pnl:getZ()
				p = pnl
		end
	end
	if p then
		if p:canClick() then
			p:__click( button )
			gui.curButton = p
		end
		if not p:isChild() then
			p:bringToFront()
		end
	end

end

function gui.buttonReleased( x, y, button, istouch )
	if gui.curButton then
		gui.curButton:onReleased( button )
		gui.curButton = nil
	end
end

function gui.wheelMoved( mx, my )
	local x,y = love.mouse.getPosition()
	local in_area = util.isInArea
	local p = gui.getModal()
	if p then
		local tbl = { p, unpack( p:getChildren() ) }
		local pnls = {}
		for k,v in pairs( tbl ) do
			local p_x,p_y = v:getPos()
			local p_w,p_h = v:getSize()
			if in_area( x, y, p_x, p_y, p_w, p_h ) then
				pnls[ #pnls + 1 ] = v
			end
		end

		local z = -math.huge
		local targ = nil
		for i = 1,#pnls do
			local p2 = pnls[ i ]
			if p2:getZ() >= z then
				z = p2:getZ()
				targ = p2
			end
		end

		if targ then
			targ:onWheelMoved( my )
		end
		return
	end

	local tbl = {}
	for k, panel in pairs( gui.objects ) do
		local p_x,p_y = panel:getPos()
		local p_w,p_h = panel:getSize()
		if in_area( x, y, p_x, p_y, p_w, p_h ) then
			tbl[ #tbl + 1 ] = panel
		end
	end

	local z = -math.huge
	local p = nil
	for i = 1,#tbl do
		local pnl = tbl[ i ]
		if pnl:getZ() >= z then
			z = pnl:getZ()
			p = pnl
		end
	end
	if p then
		p:onWheelMoved( my )
	end

end

function gui.changeResolution( w, h )
	local oldw,oldh = love.graphics.getDimensions()
	local widthScale, heightScale = w/oldw, h/oldh
	love.window.setMode( w, h )
	gui.scale( widthScale, heightScale )
end

function gui.scale( widthScale, heightScale )
	for k,panel in pairs( gui.getObjects() ) do
		local w,h = panel:getSize()
		panel:setSize( w*widthScale, h*heightScale )
		local x,y = panel:getLocalPos()
		panel:setPos( x*widthScale, y*heightScale )
	end
	gui.generateDrawOrder()
end

function gui.remove( pnl )
	table.remove( gui.objects, pnl.__tablepos )
	gui.assertPositions()
end

function gui.assertPositions()
	for i = 1,#gui.objects do
		gui.objects[ i ].__tablepos = i
	end
	gui.pos = #gui.objects -- Confirmed for not fucking shit up.
end
