
game = {}
game.paused = false 
game.states = {}
function game.pause()
	game.paused = true 
end 

function game.unpause()
	game.paused = false
end 

function game.isPaused()
	return game.paused 
end 

function game.changeState( state )
	local func = game.states.changeFuncs[ state ]
	local tFunc = game.states.thinkFuncs[ state ]
	if func then
		func()
	end 
	game.think = tFunc 
end

function game.stop()

end

game.states.changeFuncs =
{
	paused = function()
		local resume = gui.Create( "DButton" )
		resume:SetSize( 40, 20 )
		resume:Centre()
		resume:SetText( "Resume" )
		resume.DoClick = function()
			game.changeState( "running" )
		end
		game.pause()
	end,
	game = function()
		game.unpause()
	end,
	menu = function()
		local mainMenu = gui.Create( "aMenu" )
		game.stop()
	end 
} 

game.states.thinkFuncs = 
{
	paused = function()
		gui.Update()
	end, 
	game = function()
		gui.Update()
		timer.Think()
		ents.Think()
		hook.Call( "Think" )
	end,
	menu = function()
		gui.Update()
		timer.Think()
		hook.Call( "Think" )
	end 
}
