

local lt = love.timer
timer = {}
timer.List = {}

--[[----------------------------------------
	timer.create( name, delay, repeats, func, start_running )
	Used to create timers. start_running determines wether or not
	the timer starts paused.
--]]----------------------------------------
function timer.create( name, delay, repeats, func, start_running )
	local infinite = (repeats <= 0 and true or false )
	local time = lt.getTime()
	timer.List[ name ] = { delay = delay, repeats = repeats, func = func, is_running = ( start_running or true), start = time, data =
	{
		delay = delay,
		repeats = repeats,
		time_left = delay,
		infinite = infinite

	} }
end

--[[----------------------------------------
	timer.simple( delay, func, repeats )
	A simplified version of timer.create, 
	useful if you need to quickly use a timer.
	The number of repeats is optional.
--]]----------------------------------------
function timer.simple( delay, func, repeats )
	timer.create( #timer.List+1, delay, repeats or 1, func, true )
end

--[[----------------------------------------
	timer.pause( name )
	Used to pause a timer, saves repeats, time left, etc.
--]]----------------------------------------
function timer.pause( name )
	local t = timer.List[ name ]
	if t then
		if t.is_running then
			local time = lt.getTime()
			t.is_running = false
			local data = t.data 
			data.time_left = t.start + t.delay - time 
		else
		    uerror( ERROR_TIMER, "Attempted to pause an already paused timer." )
		end
	else 
		uerror( ERROR_TIMER, "Attempted to pause an invalid timer." )
	end
end 

--[[----------------------------------------
	timer.resume( name )
	Used to resume a paused timer.
--]]----------------------------------------
function timer.resume( name )
	local t = timer.List[ name ]
	if t then
		if not t.is_running then
			local time = lt.getTime()
			t.is_running = true
			local data = t.data 
			t.start = time + data.time_left
		else 
			uerror( ERROR_TIMER, "Attempted to resume a running timer." )
		end 
	else
	    uerror( ERROR_TIMER, "Attempted to resume an invalid timer.")
	end
end

--[[----------------------------------------
	timer.stop( name )
	Used to stop timers, resets all its values.
--]]----------------------------------------
function timer.stop( name )
	local t = timer.List[ name ]
	if t then
		if t.is_running then
			t.is_running = false 
		else
		     uerror( ERROR_TIMER, "Attempted to stop an already stopped timer." )
		end
	else
	    uerror( ERROR_TIMER, "Attempted to stop an invalid timer." )
	end
end 

--[[----------------------------------------
	timer.start( name )
	Restarts a stopped timer.
--]]----------------------------------------
function timer.start( name )
	local t = timer.List[ name ]
	if t then
		if not t.is_running then
			t.is_running = true 
			local data = t.data 
			t.repeats = data.repeats
			t.start = lg.getTime()
		else
		     uerror( ERROR_TIMER, "Attempted to start an already running timer." )
		end
	else
	    uerror( ERROR_TIMER, "Attempted to start an invalid timer." )
	end
end 

--[[----------------------------------------
	timer.restart( name )
	Restarts a timer, akin to immediately starting
	and stopping it.
--]]----------------------------------------
function timer.restart( name, resest )
	local reset = reset or true 
	local t = timer.List[ name ]
	if t then
		if reset then
			timer.stop( name )
			timer.start( name )
		else 
			timer.pause( name )
			timer.resume( name )
		end 
	else 
		uerror( ERROR_TIMER, "Attempted to restart an invalid timer." )
	end
end
--[[----------------------------------------
	timer.remove( name )
	Used to remove a timer.
--]]----------------------------------------
function timer.remove( name )
	timer.List[ name ] = nil
end

--[[----------------------------------------
	timer.Think()
	Internal. Do not overwrite.
--]]----------------------------------------
function timer.think()
	local time = lt.getTime()
	for k,v in pairs( timer.List ) do
		if v.is_running then
			if v.start+v.delay < time then
				v.func()
				v.repeats = v.repeats - 1
				if v.repeats <= 0 and not v.data.infinite then
					timer.remove( k )
				else
					v.start = time
				end
			end
		end
	end 
end