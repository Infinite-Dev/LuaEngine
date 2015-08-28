
local ENT = {}

function ENT:initialize()
	self:setPos( 400, 300 )
	self.r = math.random( 5, 5 )
	local circle = love.physics.newCircleShape( self.r )
	self:setShape( circle )

	local x,y = self:getNumPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	self:setFixture( fix )

	self.direction = vectorRandom()*100
	local b = self:getBody()
	b:applyForce( self.direction.x, self.direction.y )

	self.delayTime = love.timer.getTime()
end 

local delay = 0.2
function ENT:think()
	if love.timer.getTime() > self.delayTime then
		
		self.delayTime = love.timer.getTime() + delay
	end 
end 

local lg = love.graphics
function ENT:draw()
	local x,y = self:getNumPos()
	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "line", x, y, self.r )
end 

ents.registerEntity( "ent_asteroids", ENT )