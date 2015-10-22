
--[[--
 ▄▀▀█▄▄   ▄▀▀█▄▄▄▄  ▄▀▀▀▀▄  ▄▀▀▄ ▀▀▄  ▄▀▀▄ ▀▄  ▄▀▄▄▄▄  
█ ▄▀   █ ▐  ▄▀   ▐ █ █   ▐ █   ▀▄ ▄▀ █  █ █ █ █ █    ▌ 
▐ █    █   █▄▄▄▄▄     ▀▄   ▐     █   ▐  █  ▀█ ▐ █      
  █    █   █    ▌  ▀▄   █        █     █   █    █      
 ▄▀▄▄▄▄▀  ▄▀▄▄▄▄    █▀▀▀       ▄▀    ▄▀   █    ▄▀▄▄▄▄▀ 
█     ▐   █    ▐    ▐          █     █    ▐   █     ▐  
▐         ▐                    ▐     ▐        ▐   
--]]--

local lg = love.graphics
local lm = love.mouse
local PANEL = {}

local titleFont = lg.newFont( 20 )

local colors = 
{
	{ 200, 200, 200, 255 },
	{ 192, 4, 209, 255 },
	{ 255, 128, 0, 255 }
}

local start = 
{
	3,1,2,1,3,
	1,2,1,2,1,
	2,1,3,1,2,
	1,2,1,2,1,
	3,1,2,1,3,

}

local goal =
{
	3,1,2,1,3,
	1,2,1,2,1,
	2,1,3,1,2,
	1,2,1,2,1,
	3,1,2,1,3,
}

function PANEL:init()

	local master = self 

	local w,h = love.graphics.getDimensions()

	local mH = h/1.3
	self:setSize( w, mH )
	self:center()

	self.mode = false 

	self.clicks = 0

	local mX,mY = self:getPos()

	local pSZ = mH/2 
	local p1 = gui.create( "panel", self )
	p1:setPos( w/6, mH/2 - pSZ/2  )
	p1:setSize( pSZ, pSZ )
	function p1:paint( w2, h2 )
		love.graphics.setColor( 22, 22, 22, 230 )
		love.graphics.rectangle( "fill", 0, 0, w2, h2 )
	end 	

	local p2 = gui.create( "panel", self )
	p2:setPos( w - w/6 - pSZ, mH/2 - pSZ/2 )
	p2:setSize( pSZ, pSZ )
	function p2:paint( w2, h2 )
		love.graphics.setColor( 22, 22, 22, 230 )
		love.graphics.rectangle( "fill", 0, 0, w2, h2 )
	end

	local sz = pSZ/5
	self.puzzle = {}
	self.numbers = {}
	local j = 1
	for i = 1,25 do
		self.puzzle[ i ] = gui.create( "button", p1 )
		local p = self.puzzle[ i ]

		local x =  (j-1)*sz
		local y = math.floor( (i-1)/5 )*sz

		p:setPos( x, y )
		p:setSize( sz, sz )

		p.num = start[ i ]
		self.numbers[ i ] = p.num 
		p.i = i 

		p:setFont( titleFont )
		p:setTextColor( 255, 255, 255, 255 )
		p:setText( p.num )


		function p:paint( w2, h2 )
			love.graphics.setColor( unpack( colors[ p.num ] ) )
			love.graphics.rectangle( "fill", 0, 0, w, h )
		end

		function p:doClick()
			if master.mode then 
				self:change()
			else 
				self:loop()
			end 
		end

		function p:loop()
			self.num = math.loop( self.num, 1, 3 )
			self:setText( self.num )
			master.numbers[ self.i ] = self.num 
		end 

		function p:setNum( num )
			self.num = num 
			self:setText( self.num )
			master.numbers[ self.i ] = self.num 
		end

		function p:change()
			local t = master.puzzle 

			local m = i - 5
			if t[ m ] then 
					t[ m ]:loop()
			end 

			local m = i + 5
			if t[ m ] then 
					t[ m ]:loop()
			end 

			local m = i - 1
			if t[ m ] then 
				if math.ceil( i/5 ) == math.ceil( m/5 ) then 
					t[ m ]:loop()
				end 
			end 

			local m = i + 1
			if t[ m ] then 
				if math.ceil( i/5 ) == math.ceil( m/5 ) then 
					t[ m ]:loop()
				end 
			end 
			self:loop()
		end
		j = math.loop( j, 1, 5 )
	end

	local pw, ph = p1:getSize()
	local px,py = p1:getPos()
	local rButton = gui.create( "button", self  )
	rButton:setPos( px + pw/2 - (pw/4), mH/2 - pSZ/2 + ph + 10 )
	rButton:setSize( pw/2, ph/6 )
	rButton:setText( "Reset" )
	rButton:setFont( titleFont )
	function rButton:doClick()
		for i = 1,#master.puzzle do 
			master.puzzle[ i ]:setNum( start[ i ] )
		end 
	end


	local sz = pSZ/5
	self.goal = {}
	self.numbers2 = {}
	local j = 1
	for i = 1,25 do
		self.goal[ i ] = gui.create( "button", p2 )
		local p = self.goal[ i ]

		local x =  (j-1)*sz
		local y = math.floor( (i-1)/5 )*sz

		p:setPos( x, y )
		p:setSize( sz, sz )

		p.num = goal[ i ]
		self.numbers2[ i ] = p.num 
		p.i = i 

		p:setFont( titleFont )
		p:setTextColor( 255, 255, 255, 255 )
		p:setText( p.num )


		function p:paint( w2, h2 )
			love.graphics.setColor( unpack( colors[ p.num ] ) )
			love.graphics.rectangle( "fill", 0, 0, w, h )
		end

		function p:doClick()
			if master.mode then 
				self:change()
				master.clicks = master.clicks + 1
			else 
				self:loop()
			end 
		end

		function p:loop()
			self.num = math.loop( self.num, 1, 3 )
			self:setText( self.num )
			master.numbers2[ self.i ] = self.num 
		end 

		function p:setNum( num )
			self.num = num 
			self:setText( self.num )
			master.numbers2[ self.i ] = self.num 
		end

		function p:change()
			local t = master.goal

			local m = i - 5
			if t[ m ] then 
					t[ m ]:loop()
			end 

			local m = i + 5
			if t[ m ] then 
					t[ m ]:loop()
			end 

			local m = i - 1
			if t[ m ] then 
				if math.ceil( i/5 ) == math.ceil( m/5 ) then 
					t[ m ]:loop()
				end 
			end 

			local m = i + 1
			if t[ m ] then 
				if math.ceil( i/5 ) == math.ceil( m/5 ) then 
					t[ m ]:loop()
				end 
			end 
			self:loop()
		end
		j = math.loop( j, 1, 5 )
	end

	local pw, ph = p2:getSize()
	local px,py = p2:getPos()
	local rButton = gui.create( "button", self  )
	rButton:setPos( px + pw/2 - (pw/4), mH/2 - pSZ/2 + ph + 10 )
	rButton:setSize( pw/2, ph/6 )
	rButton:setText( "Reset" )
	rButton:setFont( titleFont )
	function rButton:doClick()
		for i = 1,#master.goal do 
			master.goal[ i ]:setNum( goal[ i ] )
		end 
		master.clicks = 0
	end 

	local w,h = love.graphics.getDimensions()
	local sButton = gui.create( "button" )
	sButton:setPos( w/2 - (w/4), 10 )
	sButton:setSize( w/2, 50 )
	sButton:setText( "Begin Brute Force")
	function sButton:doClick()
		master:crack()
	end 

	local w,h = self:getSize()
	self.toggle = gui.create( "button", self )
	self.toggle:setPos( w/2 - (w/8), 10 )
	self.toggle:setSize( w/4, 50 )
	self.toggle:setText( "Toggle Mode: "..1 )
	self.toggle:setFont( titleFont )
	self.toggle.num = 1
	function self.toggle:doClick()
		master:toggleMode()
	end 

end 

function PANEL:toggleMode()
	self.mode = not self.mode 
	self.toggle.num = math.loop( self.toggle.num, 1, 2 )
	self.toggle:setText( "Toggle Mode: "..self.toggle.num )
end 

function PANEL:reset()
	for i = 1,#self.puzzle do
		self.puzzle[ i ]:setNum( start[ i ] )
	end
end 

function PANEL:crack()
	self.solved = false 
	local j = 1
	local tbl = {}
	local num = (self.clicks > 0 and self.clicks or 5)
	local preSolve = table.copy( self.numbers )
	while not self.solved do
		for i = 1,num do 
			local targ = math.random( 1,25 )
			self.puzzle[ targ ]:change()
			tbl[ i ] = targ 
			local b = true 
			for i2 = 1,#self.numbers do
				if not (self.numbers[ i2 ] == self.numbers2[ i2 ]) then 
					b = false 
					break 
				end 
			end
			self.solved = b 
			if self.solved then 
				break 
			end 
		end
		if not self.solved then 
			self:reset()
			tbl = {}
		end 
	end
	
	local w,h = love.graphics.getDimensions()
	local panel = gui.create( "frame" )
	panel:setSize( w/4, w/4 )
	panel:center()
	panel:setTitle( "Solution Found!" )
	panel.tbl = tbl 
	function panel:paint( w2, h2 )

		love.graphics.setColor( 22, 22, 22, 255 )
		love.graphics.rectangle( "fill", 0, 0, w2, h2 )

		love.graphics.setColor( 40, 40, 40, 255 )
		love.graphics.rectangle( "line", 0, 0, w2, h2 )

		love.graphics.setColor( 255, 255, 255, 255 )
		love.graphics.setFont( titleFont )
		for i = 1,#self.tbl do
			local p = self.tbl[ i ]
			local f = math.ceil( p/5 )
			local t = f.." : "..(p-((f-1)*5))

			local font = love.graphics.getFont()
			local xsz,ysz = font:getWidth( t ),font:getHeight( t )
			love.graphics.print( t, w2/2 - xsz/2, 25 * i )
		end 
	end 

	for i = 1,#self.puzzle do 
		self.puzzle[ i ]:setNum( preSolve[ i ] )
	end  

end 

function PANEL:paint( w, h )

	lg.setColor( 33, 33, 33, 240 )
	lg.rectangle( "fill", 0, 0, w, h )

	lg.setColor( 255, 255, 255, 255 )
	lg.setFont( titleFont )

	local title = "Clicks"
	local font = love.graphics.getFont()
	local tw,th = font:getWidth( title ),font:getHeight( title )
	lg.print( title, w - tw*1.65, h/2 )

	local title = self.clicks 
	local font = love.graphics.getFont()
	local tw,th = font:getWidth( title ),font:getHeight( title )
	lg.print( title, w - tw - 60, h/2 + 30 )

end
gui.register( "notpron16", PANEL, "panel" )