
local ENT = {}

local size = 20
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
	body:setLinearDamping( 0.45 )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	self:setFixture( fix )
	self.centreColor = { 255, 255, 255, 255 }
	self.damage = 25 
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
	if not p:isAlive() then return end 
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

ents.registerEntity( "npc_drone", ENT )