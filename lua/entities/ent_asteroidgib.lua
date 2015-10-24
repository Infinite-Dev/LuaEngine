
local ENT = {}

function ENT:initialize()

	self.liveTime = love.timer.getTime() + 1.2

end  

function ENT:generate( min, max )

	self.r = math.random( min, max )

	local circle = love.physics.newCircleShape( self.r or math.random( self.min, self.max ) )
	self:setShape( circle )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( self.r )
	self:setBody( body )

	local vec = vectorRandom()*20
	body:applyForce( vec.x, vec.y )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	fix:setCategory( 2 )
	self:setFixture( fix )

end 

function ENT:think()
	if love.timer.getTime() > self.liveTime then 
		self:remove()
	end 
end 

local lg = love.graphics
function ENT:draw()
	local x,y = self:getPos()
	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "line", x, y, self.r )
end 

ents.registerEntity( "ent_asteroidgib", ENT )