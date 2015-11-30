
local ENT = {}

local size = 350
local range = 150
local alert = 300
local speed = 50
local mass = 100
local damage = 25 
local hp = 200

local laserSpeed = 500
local events =
{
	function( self )
		self:doLaserAttack( 0.30, 3, 10, laserSpeed )
	end,

	function( self )

	end 
}
function ENT:initialize()

	local circle = love.physics.newCircleShape( size )
	self:setShape( circle )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( 100 )
	body:setLinearDamping( 100 )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	fix:setGroupIndex( -20 )
	self:setFixture( fix )
	self.centreColor = { 255, 255, 255, 255 }
	self.damage = 8 
	self.nextTargTime = 0 
	self.targChangeDelay = 1.5
	self.targPos = vector( 0, 0 )
	self.fireDelay = 2
	self.nextFireTime = love.timer.getTime() + self.fireDelay 
	self.bulletSpeed = 250
	self:setHealth( hp )
	self:setMaxHealth( hp )
	self:setBoss( true )
	self:setName( "Mother Ship" )
	self:setDescription( "...we have a problem.")

	self:setEventTable( events )
	self.eventTimer = love.timer.getTime() + love.math.random( 5, 12 )

end 

function ENT:collisionPostSolve( ent, coll, norm1, tan1, norm2, tan2  )
	if not isEntity( ent ) then return end 
	if ent:getClass() == "ent_player" and ent:isAlive() then 
		ent:takeDamage( self.damage )
	end 
end 

function ENT:onSpawn()
end 

function ENT:think()

	local x,y = self:getPos()
	local w,h = love.graphics.getDimensions() 

	local p = game.getPlayer()
	if p:isValid() then 
		self:logic( x, y, w, h, p )
	end 

end 

function ENT:logic( x, y, w, h, p )

	local t = love.timer.getTime()
	local e = love.math.random( 1, #self:getEventTable() )
	local n = love.math.random( 10, 14 )
	if self:shouldDoEvent() then 
		self:doEvent( e, n )
	end

	if self.eventThink then 
		self:eventThink( t )
	end  


end 

local radian = math.pi*2
function ENT:doLaserAttack( delay, dur, damage, speed )
	local time = love.timer.getTime()
	self.laserTime = time + dur 
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
				local norm = (vec2-vec):normalized()
				self:fireBullet( norm )
			end 
			self.laserDelay = t + self.laserDelayAdd
		end
		if t > self.laserTime then 
			self.laserAttack = false 
		end 
	end )
end

function ENT:fireBullet( norm )
	local x,y = self:getPos()
	local vec = vector( x, y )
	local bulletData = {}
	bulletData.damage = self.laserDamage
	bulletData.force = 100 
	bulletData.startPos = vec
	bulletData.dir = norm 
	bulletData.size = 14
	bulletData.owner = self 
	bulletData.speed = self.laserSpeed 
	bulletData.color = { 0, 255, 0, 255 }
	bulletData.drawMode = BULLET_DRAWMODE_LINE
	bulletData.angle = norm:toAngle() + radian/4
	game.createBullet( bulletData )
end 

function ENT:onSpawn()

end 

function ENT:getSpawnPosition()
	local w,h = love.graphics.getDimensions()
	return w/2, -size*0.6
end

local lg = love.graphics
local numCircles = 14
local circleSize = size*0.08
local radians = math.pi*2 
local circleOrbit = size - circleSize*1.5
local blur = 20
function ENT:draw( t )
	local x,y = self:getPos()

	local t = t*0.5
	for i = 1,numCircles do 
		local p = (i/numCircles)*radians
		local angle = t + p 
		for i = 1,blur do 
			lg.setColor( 31, 255, 31, 15*(1 - (i/blur) ) )
			lg.arc( "fill", x, y, size*(1+(i/250)), -angle, -angle + math.pi/(numCircles), 10 )
		end 
	end

	lg.setColor( 0, 0, 0, 255 )
	lg.circle( "fill", x, y, size )

	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "line", x, y, size )

	lg.setColor( unpack( self.centreColor ) )
	lg.circle( "fill", x, y, size*0.65 )
	for i = 1,numCircles do 
		local p = (i/numCircles)*radians
		local angle = t + p - (math.pi/(numCircles)/2)
		local cx = math.cos( -angle )*circleOrbit
		local cy = math.sin( -angle )*circleOrbit
		lg.circle( "fill", x + cx, y + cy, circleSize )
	end 
end 

ents.registerEntity( "npc_ufoboss", ENT, "npc_base" )