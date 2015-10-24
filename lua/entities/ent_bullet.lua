
local ENT = {}

function ENT:initialize() 

	self.r = 2
	local circle = love.physics.newCircleShape( self.r )
	self:setShape( circle )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( self.r )
	body:setLinearDamping( 0 )
	body:setBullet( true )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	fix:setDensity( 1 )
	fix:setMask( 2 )
	self:setFixture( fix )

end 

function ENT:setBulletData( x, y, xdir, ydir, speed )
	self:setPos( x, y )
	local b = self:getBody()
	local dt = love.timer.getDelta()
	b:applyForce( xdir*speed, ydir*speed )
end 

function ENT:collisionPostSolve( ent, coll, norm1, tan1, norm2, tan2  )
	if isEntity( ent ) and ent:getClass() == "ent_asteroid" then 
		ent:destroy()
		self:remove()
	end 
end 

function ENT:think()

	local x,y = self:getPos()
	local w,h = love.graphics.getDimensions()

	local mult = 1.2
	local compare = self.r*mult
	local x2,y2 = x + compare, y + compare
	local x3,y3 = x - compare, y - compare

	if x3 > w + compare/2 then 
		self:remove()
	elseif y3 > h + compare/2 then
		self:remove()
	elseif x2 < -compare/2 then 
		self:remove()
	elseif y2 < -compare/2 then 
		self:remove()
	end  

end 

local lg = love.graphics 
function ENT:draw()

	local x,y = self:getPos()
	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "fill", x, y, self.r )

end 
ents.registerEntity( "ent_bullet", ENT )