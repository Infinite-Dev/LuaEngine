
local ENT = {}

function ENT:initialize()

	local sz = 7
	local tbl = {}
	local points = 3
	local incr = 360/points 
	for i = 1,points do 
		if i == 3 then 
			sz = 13
		end 
		tbl[ #tbl+1 ] = math.sin( math.rad( incr*i ) )*sz 
		tbl[ #tbl+1 ] = math.cos( math.rad( incr*i ) )*sz 
	end 

	local poly = love.physics.newPolygonShape( unpack( tbl ) )
	self:setShape( poly )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( 35 )
	body:setAngularDamping( 100 )
	body:setLinearDamping( 1.5 )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	fix:setDensity( 1 )
	self:setFixture( fix )

	self.alive = true 
	self.health = 100
	self.moving = false 

	self.bulletDelay = 0 
	self.fireDelay = 0.25
	self.shouldGib = false
	self.gibDelay = 0 

end 

function ENT:getHealth()
	return self.health 
end 

function ENT:setHealth( hp )
	self.health = math.max( hp, 0 ) 
end 

function ENT:isAlive()
	return self.alive
end 

function ENT:setAlive( bool )
	self.alive = bool 
end 

function ENT:setRespawnTime( t )
	self.respawnTime = love.timer.getTime() + t 
end 

function ENT:getRespawnTime()
	return self.respawnTime or 0 
end 

function ENT:getDisplayRespawnTime()
	return math.max( self:getRespawnTime() - love.timer.getTime(), 0 )
end 

function ENT:shouldRespawn()
	return self:getRespawnTime() < love.timer.getTime()
end 

function ENT:doDeath()

	self:setAlive( false )
	self:setRespawnTime( 2 )
	self.moving = false 
	local b = self:getBody()
	b:setLinearDamping( 0.4 )
	b:setAngularDamping( 0.7 )

	self.gibDelay = love.timer.getTime() + 1
	self.shouldGib = true 

end 

function ENT:collisionPostSolve( ent, coll, norm1, tan1, norm2, tan2  )
	if self:isAlive() then 
		if isEntity( ent ) and ent:getClass() == "ent_asteroid" then 

			local b = self:getBody()
			local d,e,f,g = b:getMassData()

			local mult = norm1/11
			local dmg = (f^2)*mult + (norm1^2)*mult + 3

			self:setHealth( self:getHealth() - dmg )
			if self:getHealth() <= 0 then 
				self:doDeath()
			end 

		end 
	end 
end 

function ENT:getShootPos()
	local body = self:getBody()
	local points = {body:getWorldPoints( self:getShape():getPoints() )}
	local x = points[ 3 ]
	local y = points[ 4 ]
	return x,y 
end 

function ENT:getAimDir()
	local b = self:getBody()
	local a = b:getAngle() + math.pi/2
	local x = math.cos( a )
	local y = math.sin( a )
	return x, y 
end 

local isDown = love.keyboard.isDown
local rMax = math.pi*2
local speed = 12
local sens = 6
function ENT:think()

	local t = love.timer.getTime()
	if self:isAlive() then 

		local b = self:getBody()

		if isDown( "w" ) and t > self.bulletDelay then 
			local bullet = ents.create( "ent_bullet" )
			local x,y = self:getShootPos()
			local xdir,ydir = self:getAimDir()
			bullet:setBulletData( x, y, xdir, ydir, 100 )
			self.bulletDelay = t + self.fireDelay 
		end 

		if isDown( "s" ) then 
			local a = b:getAngle() + math.pi/2
			local x = math.cos( a )*speed
			local y = math.sin( a )*speed
			b:applyForce( x, y )
			self.moving = true 
		else 
			self.moving = false 
		end 

		local dt = love.timer.getDelta()
		if isDown( "a" ) then 
			local a = b:getAngle()
			b:setAngle( a - sens*dt )
		end 

		if isDown( "d" ) then 
			local a = b:getAngle()
			b:setAngle( a + sens*dt )
		end 

	end


	local x,y = self:getPos()
	local w,h = love.graphics.getDimensions()

	local mult = 1.1
	local compare = 10
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

	if t > self.gibDelay and self.shouldGib then 

		self:gib()

		self:remove()

	end 

end 

function ENT:gib()
	local min,max = 0.9,1.1
	local tspeed = 1000

	local body = self:getBody()
	local bX,bY = body:getPosition()
	local lpoints = {self:getShape():getPoints()}
	local wpoints = {body:getWorldPoints( self:getShape():getPoints() )}
	local pNo = { 1, 2, 3, 4, 3, 4, 5, 6, 1, 2, 5, 6 }
	local xa = body:getAngularVelocity()

	for i = 1,3 do 

		local j = (i-1)*4
		local xf,yf = body:getLinearVelocity()
		xf = xf*math.random( min, max )
		yf = yf*math.random( min, max )

		local x1, y1, x2, y2 = lpoints[pNo[ j + 1 ]], lpoints[pNo[ j + 2 ]], lpoints[pNo[ j + 3 ]], lpoints[pNo[ j + 4 ]]

		local gib = ents.create( "ent_playergib" )
		gib:setUp( x1, y1, x2, y2, bX, bY )

		local b = gib:getBody()
		b:setLinearVelocity( xf, yf )

		b:setAngularVelocity( xa*math.random( -1, 1 ) )


		local m1,m2 = (x1+x2)/2,(y1+y2)/2
		local norm = ( Vector( m1, m2 ) - Vector( bX, bY ) ):normalized()*3000
		local t = math.random( -tspeed, tspeed )
		b:applyForce( norm.x, norm.y )

	end 
end 

local lg = love.graphics 
local incr = 360/3
local sz = 10 
function ENT:draw()

	local body = self:getBody()
	lg.setColor( 255, 255, 255, 255 )

	local points = {body:getWorldPoints( self:getShape():getPoints() )}
	lg.polygon( "line", unpack( points ) )
	
	if self.moving then 
		local x = points[ 1 ]
		local y = points[ 2 ]

		local v = Vector( x, y )

		local x2 = points[ 5 ]
		local y2 = points[ 6 ]

		local v2 = Vector( x2, y2 )

		local a = body:getAngle() + math.pi/2
		local aX = math.cos( a )
		local aY = math.sin( a )

		local norm = (v2 - v):normalized()
		local dist = math.distance( x, y, x2, y2 )
		local distNorm = norm*dist 
		local gap = norm*dist/3.5 

		local x3 = x + gap.x - aX 
		local y3 = y + gap.y - aY

		local x4 = x + distNorm.x - gap.x - aX 
		local y4 = y + distNorm.y - gap.y - aY 

		local midX = (x + x2)/2 
		local midY = (y + y2)/2

		local r = math.random( 5, 6 )
		local x5 = midX - aX*r
		local y5 = midY - aY*r

		lg.setColor( 255, 120, 0, 255 )
		lg.polygon( "line", x3, y3, x4, y4, x5, y5 )
	end 


end 
ents.registerEntity( "ent_player", ENT )