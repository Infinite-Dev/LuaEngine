
local ENT = {}

local size = 60
local range = 500
local alert = 700
local speed = 50
local mass = 100
local damage = 100
local colDamage = 20
local hp = 150
local bulletSpeed = 120
local numBullets = 28
local damage = 10
local numDrones = 2
local laserSpeed = 200
local eTable =
{
	function( self )
		local x,y = self:getPos()
		local spawnArea = size*1.5
		for i = 1,numDrones do
			local r = (i/numDrones)*(2*math.pi)
			local x2,y2 = math.sin( r )*spawnArea, math.cos( r )*spawnArea
			local norm = ( vector( x, y ) - vector( x2, y2 ) ):normalized()
			local drone = ents.create( "npc_drone" )
			drone:setPos( x + x2 , y + y2 )
			drone:applyForce( norm*250 )
		end
	end,
	function( self )
		local x,y = self:getPos()
		for i = 1,numBullets do
			local p = (i/numBullets)*(2*math.pi)
			local bulletX = math.sin( p )*(size*1.05) + x
			local bulletY  = math.cos( p )*(size*1.05) + y

			local vec = vector( x, y )
			local vec2 = vector( bulletX, bulletY )
			local norm = (vec2-vec):normalized()

			local bulletData = {}
			bulletData.damage = damage
			bulletData.force = 1
			bulletData.startPos = vec
			bulletData.dir = norm
			bulletData.size = 2
			bulletData.owner = self
			bulletData.speed = bulletSpeed
			bulletData.color = { 0, 102, 255, 255 }
			game.createBullet( bulletData )

		end
	end,
	function( self )
		self:doSpinAttack( 0.06, 2, 2, 10, 80 )
	end,
	function( self )
		self:doLaserAttack( 0.03, 1.5, 10, laserSpeed )
	end
}
function ENT:initialize()
	local circle = love.physics.newCircleShape( size )
	self:setShape( circle )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( 100 )
	body:setLinearDamping( 0.45 )
	self:setBody( body )

	local d = 5
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	fix:setGroupIndex( -20 )
	self:setFixture( fix )

	self.centreColor = { 255, 255, 255, 255 }
	self.damage = colDamage
	self:setHealth( hp )
	self:setMaxHealth( hp )
	self.eventTimer = love.timer.getTime() + love.math.random( 5, 12 )

	self:setBoss( true )
	self:setName(  "Mega Drone" )
	self:setDescription( "It's... uh... big." )

	self:setEventTable( eTable )
end

local bounceForce = 300
function ENT:collisionPostSolve( ent, coll, norm1, tan1, norm2, tan2  )
	if not isEntity( ent ) then return end
	if ent:getClass() == "ent_player" and ent:isAlive() then
		local x,y = ent:getPos()
		local vec1 = vector( x, y )
		local x,y = self:getPos()
		local vec2 = vector( x, y )
		local norm = ( vec1 - vec2 ):normalized()
		ent:setVelocity( norm*bounceForce )
		ent:takeDamage( self.damage )
	end
end

function ENT:spawn()
	local w,h = love.graphics.getDimensions()
	local midx, midy = w/2, h/2
	local x,y = self:getPos()
	local vec1 = vector( midx, midy )
	local vec2 = vector( x, y )
	local norm = (vec1-vec2):normalized()
	self:setVelocity( norm*200 )
end

function ENT:doSpinAttack( delay, loops, duration, bulletDamage, bulletSpeed )
	self.spinAngle = 0
	self.spinDamage = bulletDamage
	self.spinFireDelay = delay
	self.spinStartTime = love.timer.getTime()
	self.nextSpinFire = 0
	self.spinLoops = (2*math.pi)*loops
	self.spinDuration = duration
	self.spinRealTime = self.spinStartTime + self.spinDuration
	self.spinBulletSpeed = bulletSpeed
	self.spinAttack = true

	self:setEventThink( function( self, time )
		local x,y = self:getPos()
		if self.spinAttack then
			if time < self.spinRealTime then
				if time >= self.nextSpinFire then
					local r = size*1.05
					local bulletX = math.sin( self.spinAngle )*r + x
					local bulletY = math.cos( self.spinAngle )*r + y

					local vec = vector( x, y )
					local vec2 = vector( bulletX, bulletY )
					local norm = (vec2-vec):normalized()

					local bulletData = {}
					bulletData.damage = self.spinDamage
					bulletData.force = 1
					bulletData.startPos = vec
					bulletData.dir = norm
					bulletData.size = 2
					bulletData.owner = self
					bulletData.speed = self.spinBulletSpeed
					bulletData.color = { 0, 102, 255, 255 }
					game.createBullet( bulletData )

					self.nextSpinFire = time + self.spinFireDelay
				end
				local p = math.min( (love.timer.getTime()-self.spinStartTime)/self.spinDuration, 1 )
				self.spinAngle = self.spinLoops*p
			else
				self.spinAttack = false
			end
		end
	end)
end

function ENT:doLaserAttack( delay, dur, damage, speed )
	local t = love.timer.getTime()
	self.laserTime = t + dur
	self.laserDelayAdd = delay
	self.laserDelay = 0
	self.laserAttack = true
	self.laserDamage = damage
	self.laserSpeed = speed

	self:setEventThink( function( self, t )
		if not self.laserAttack then return end
		local x,y = self:getPos()
		if t > self.laserDelay then
			local p = game.getPlayer()
			if p:isValid() then
				local px,py = p:getPos()
				local vec = vector( x, y )
				local vec2 = vector( px, py )
				local pdir = p:getVelocity( true )
				local vel = pdir:len()
				local vec3 = vec2 + pdir*( vel/laserSpeed*0.8 )
				local norm = (vec3-vec):normalized()
				local bulletData = {}
				bulletData.damage = self.laserDamage
				bulletData.force = 1
				bulletData.startPos = vec
				bulletData.dir = norm
				bulletData.size = 2
				bulletData.owner = self
				bulletData.speed = self.laserSpeed
				bulletData.color = { 0, 102, 255, 255 }
				game.createBullet( bulletData )
			end
			self.laserDelay = t + self.laserDelayAdd
		end
		if t > self.laserTime then
			self.laserAttack = false
		end
	end )
end

function ENT:think()

	local x,y = self:getPos()
	local w,h = love.graphics.getDimensions()
	local time = love.timer.getTime()

	local e = love.math.random( 1, #self:getEventTable() )
	local n = love.math.random( 5, 8 )
	if self:shouldDoEvent() then
		self:doEvent( e, n )
	end

	if self.eventThink then
		self:eventThink( time )
	end

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
	if not p:isValid() then return end

	local pVec = vector( p:getPos() )
	local eVec = vector( self:getPos() )
	if pVec:distance( eVec ) <= range then
		local norm = (pVec-eVec):normalized()*speed
		self:applyForce( norm )
		self.centreColor = { 255, 25, 25, 255 }
	elseif pVec:distance( eVec ) <= alert then
		local norm = (pVec-eVec):normalized()*(speed/3)
		self:applyForce( norm )
		self.centreColor = { 200, 120, 0, 255 }
	else
		self.centreColor = { 0, 255, 0, 255 }
	end
end

function ENT:getSpawnPos()
	local w,h = love.graphics.getDimensions()
	return w/2 - size/2, -size
end

local lg = love.graphics
function ENT:draw()
	local x,y = self:getPos()
	lg.setColor( 0, 0, 0, 255 )
	lg.circle( "fill", x, y, size )

	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "line", x, y, size )

	lg.setColor( unpack( self.centreColor ) )
	lg.circle( "line", x, y, size*0.4 )
	lg.circle( "line", x, y, 1 )
end

ents.registerEntity( "npc_droneboss", ENT, "npc_base" )
