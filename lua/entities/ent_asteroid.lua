
local ENT = {}

function ENT:initialize()
	self.min = asteroids.minSize 
	self.max = asteroids.maxSize 
	self.r = math.random( self.min, self.max )
	self.alive = true 
end 

function ENT:generate()
	local circle = love.physics.newCircleShape( self.r or math.random( self.min, self.max ) )
	self:setShape( circle )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( self.r )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	self:setFixture( fix )
end 

function ENT:setMinMax( min, max )
	self.min = min 
	self.max = max 
end 

function ENT:setSize( sz )
	if not sz then
		self.r = math.random( self.min, self.max )
	else 
		self.r = sz 
	end 
end 

function ENT:move( dir )
	self.direction = dir 
	self:getBody():applyForce( dir.x, dir.y )
end 

function ENT:moveRandom( mul )
	self.direction = vectorRandom()*mul 
	local b = self:getBody()
	b:applyForce( self.direction.x, self.direction.y )
end 

function ENT:destroy()
	self.alive = false 
end 

function ENT:think()

	local x,y = self:getPos()
	local w,h = love.graphics.getDimensions()

	local mult = 1.2
	local compare = self.r*mult
	local x2,y2 = x + compare, y + compare
	local x3,y3 = x - compare, y - compare

	if x3 > w + compare/2 then 
		self:setPos( -compare, y )
	elseif y3 > h + compare/2 then
		self:setPos( x, -compare )
	elseif x2 < -compare/2 then 
		self:setPos( w + compare, y )
	elseif y2 < -compare/2 then 
		self:setPos( x, h + compare )
	end  

	if not self.alive then 
		if self.r > 15 then 
			local num = 2
			local sz = self.r/num
			for i = 1,num do 
				local vec = vectorRandom()*10
				local x,y = self:getPos()
				local ast = ents.create( "ent_asteroid" )
				ast:setPos( x + vec.x, y + vec.y )
				ast:setSize( sz )
				ast:generate()
				local mul = ast.r*asteroids.speed*( self.r/asteroids.maxSize ) 
				ast:moveRandom( mul )
			end 
		end 
		self:remove()
	end 

end 

local lg = love.graphics
function ENT:draw()
	local x,y = self:getPos()
	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "line", x, y, self.r )
end 

ents.registerEntity( "ent_asteroid", ENT )