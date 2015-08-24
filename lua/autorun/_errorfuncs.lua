
ERROR_TIMER = "TIMER"
ERROR_HOOK = "HOOK"
ERROR_UTIL = "UTIL"
ERROR_GUI = "GUI"
ERROR_VECTOR = "VECTOR"
ERROR_STRING = "STRING"
ERROR_TABLE = "TABLE"
ERROR_ENGINE = "ENGINE"
ERROR_MODULE = "MODULE"
ERROR_ENTITY = "ENTITY"

WINDOW_ERROR = "error"
WINDOW_INFO = "info"
WINDOW_WARNING = "warning"

function uerror( msg, err )
	local msg = tostring( msg )
	local err = tostring( err )
	return print( "["..msg.."] "..err )
end

local function error_printer( msg, layer )
	print( ( debug.traceback( "Error: " .. tostring( msg ), 1+( layer or 1 ) ):gsub( "\n[^\n]+$", "" ) ) )
end
 
function love.errhand( msg )
	msg = tostring( msg )
 
	error_printer( msg, 2 )
 
	if not love.window or not love.graphics or not love.event then return end
 
	if not love.graphics.isCreated() or not love.window.isCreated() then
		local success, status = pcall( love.window.setMode, 800, 600 )
		if not success or not status then
			return
		end
	end
 
	-- Reset state.
	if love.mouse then
		love.mouse.setVisible( true )
		love.mouse.setGrabbed( false )
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs( love.joystick.getJoysticks() ) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local font = love.graphics.setNewFont( math.floor( love.window.toPixels(14) ) )
 
	local sRGB = select( 3, love.window.getMode() ).srgb
	if sRGB and love.math then
		love.graphics.setBackgroundColor( love.math.gammaToLinear( 4, 4, 4 ) )
	else
		love.graphics.setBackgroundColor( 4, 4, 4 )
	end
 
	love.graphics.setColor( 0, 255, 0 )
 
	local trace = debug.traceback()
 
	love.graphics.clear()
	love.graphics.origin()
 
	local err = {}
 
	table.insert( err, "Error\n" )
	table.insert( err, msg.."\n\n" )
 
	for l in string.gmatch( trace, "(.-)\n" ) do
		if not string.match( l, "boot.lua" ) then
			l = string.gsub( l, "stack traceback:", "Traceback\n" )
			table.insert( err, l )
		end
	end
	
	local p = table.concat( err, "\n" )
 
	p = string.gsub( p, "\t", "" )
	p = string.gsub( p, "%[string \"(.-)\"%]", "%1" )
 
	local function draw()
		local pos = love.window.toPixels(70)
		love.graphics.clear()
		love.graphics.printf( p, pos, pos, love.graphics.getWidth() - pos )
		love.graphics.present()
	end
 
	while true do
		love.event.pump()
 
		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return
			end
			if e == "keypressed" and a == "escape" then
				return
			end
		end
 
		draw()
 
		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end