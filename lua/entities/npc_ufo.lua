
local ENT = {}

local size = 30
local range = 150
local alert = 300
local speed = 50
local mass = 100
local damage = 25 
function ENT:initialize()
	local circle = love.physics.newCircleShape( size )
	self:setShape( circle )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( 100 )
	body:setLinearDamping( 1 )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	fix:setGroupIndex( -20 )
	self:setFixture( fix )
	self.centreColor = { 255, 255, 255, 255 }
	self.damage = 5 
	self.nextTargTime = 0 
	self.targChangeDelay = 1.5
	self.targPos = vector( 0, 0 )
	self.fireDelay = 2
	self.nextFireTime = love.timer.getTime() + self.fireDelay 
	self.bulletSpeed = 250
	self:setHealth( 2 )
	self:setMaxHealth( 2 )
end 

function ENT:collisionPostSolve( ent, coll, norm1, tan1, norm2, tan2  )
	if not isEntity( ent ) then return end 
	if ent:getClass() == "ent_player" and ent:isAlive() then 
		ent:takeDamage( self.damage )
		self:takeDamage( 1 )
	end 
end 

function ENT:onSpawn()
	local w,h = love.graphics.getDimensions()
	local midx, midy = w/2, h/2 
	local x,y = self:getPos()
	local vec1 = vector( midx, midy )
	local vec2 = vector( x, y )
	local norm = (vec1-vec2):normalized()
	self:setVelocity( norm*200 )
end 

function ENT:think()

	local x,y = self:getPos()
	local w,h = love.graphics.getDimensions()

	local mult = 1.1
	local compare = size
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

	local p = game.getPlayer()
	if p:isValid() then 
		self:logic( x, y, w, h, p )
	end 

end 

local orbitalDist = 150
local radian = math.pi*2 
local pushCheck = orbitalDist - size/2 
local bulletDist = orbitalDist*1.2
function ENT:logic( x, y, w, h, p )

	local t = love.timer.getTime()
	local px,py = p:getPos()

	if t > self.nextTargTime then 	

		local r = love.math.random()*radian
		local targx = px + math.cos( r )*orbitalDist
		local targy = py + math.sin( r )*orbitalDist 

		self.targPos = vector( targx, targy )

		self.nextTargTime = t + self.targChangeDelay
	end 

	local x,y = self:getPos()
	local vec = vector( x, y )
	local targ = self.targPos
	local norm = ( targ - vec ):normalized()
	self:applyForce( norm*150 )

	local pvec = vector( px, py )
	local dist = pvec:distance( vec )
	if dist <= pushCheck then 
		local norm = ( vec - pvec ):normalized()
		self:applyForce( norm*300 )
	end

	if dist <= bulletDist then 
		if t >= self.nextFireTime then 
			local norm = ( pvec - vec ):normalized()
			self:fireBullet( norm )
			self.nextFireTime = t + self.fireDelay
		end 
	end 

end 

function ENT:fireBullet( norm )
	local x,y = self:getPos()
	local vec = vector( x, y )
	local bulletData = {}
	bulletData.damage = self.damage
	bulletData.force = 0 
	bulletData.startPos = vec
	bulletData.dir = norm 
	bulletData.size = 4
	bulletData.owner = self 
	bulletData.speed = self.bulletSpeed 
	bulletData.color = { 0, 255, 0, 255 }
	bulletData.drawMode = BULLET_DRAWMODE_LINE
	bulletData.angle = norm:toAngle() + radian/4
	game.createBullet( bulletData )
end 

local lg = love.graphics
local numCircles = 7
local circleSize = 3
local radians = math.pi*2 
local circleOrbit = size - circleSize*3
function ENT:draw( t )
	local x,y = self:getPos()
	lg.setColor( 0, 0, 0, 255 )
	lg.circle( "fill", x, y, size )

	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "line", x, y, size )

	lg.setColor( unpack( self.centreColor ) )
	lg.circle( "fill", x, y, size - circleOrbit )
	for i = 1,numCircles do 
		local p = (i/numCircles)*radians
		local cx = math.cos( t + p )*circleOrbit
		local cy = math.sin( t + p )*circleOrbit
		lg.circle( "fill", x + cx, y + cy, circleSize )
	end 
end 

ents.registerEntity( "npc_ufo", ENT, "npc_base" )