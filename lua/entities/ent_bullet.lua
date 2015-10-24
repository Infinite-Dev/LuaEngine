
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

	self.drawx = x 
	self.drawy = y 

end 

function ENT:setBulletData( x, y, xdir, ydir, speed, angle )
	self:setPos( x, y )
	local b = self:getBody()
	b:applyForce( xdir*speed, ydir*speed )

	self:setAngle( angle )

	local a = angle + math.pi/2
	local a2 = angle + math.pi*1.5
	self.xadd = math.cos( a )*self.r 
	self.xadd2 = math.cos( a2 )*self.r 
	self.yadd = math.sin( a )*self.r
	self.yadd2 = math.sin( a2 )*self.r 

end 

function ENT:collisionPostSolve( ent, coll, norm1, tan1, norm2, tan2  )
	if isEntity( ent ) and ent:getClass() == "ent_asteroid" then
		local x,y = coll:getPositions() 
		ent:destroy( x, y )
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

local math = math 
local lg = love.graphics 
function ENT:draw()

	local x,y = self:getPos()
	local x1,y1 = self.xadd + x,self.yadd + y
	local x2,y2 = self.xadd2 + x,self.yadd2 + y

	lg.setColor( 255, 230, 0, 255 )
	lg.line( x1, y1, x2, y2 )

end 
ents.registerEntity( "ent_bullet", ENT )