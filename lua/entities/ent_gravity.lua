
local ENT = {}

function ENT:initialize()
	self.r = 5
	self.alive = true
end

function ENT:onSpawn()
	self:generate()
end

function ENT:generate()
	local circle = love.physics.newCircleShape( self.r )
	self:setShape( circle )

	local x,y = self:getPos().x, self:getPos().y
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( self.r )
	self:setBody( body )

	local d = 5
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	self:setFixture( fix )
	self:setCollisionType( COLLISION_TYPE_ENTITY )
end

function ENT:setSize( sz )
	if not sz then
		self.r = love.math.random( self.min, self.max )
	else
		self.r = sz
	end
	self:generate()
end

function ENT:onDeath()
end

function ENT:collisionPostSolve( ent, coll, norm1, tan1, norm2, tan2  )

end

local G =  6.673 * 10^-11
function ENT:think()
	local pos = self:getPos()
	for k,v in pairs( ents.getAll() ) do
		if v ~= self then
			local pos2 = v:getPos()
			local m1 = self:getMass()
			local m2 = v:getMass()
			local d  = pos:distance( pos2 )
			local dG = d/love.physics.getMeter()

			local f  = G*m1*m2/(dG^2)
			local norm = ( pos - pos2 ):normalized()

			v:applyForce( norm*f )
		end
	end
end

local lg = love.graphics
function ENT:draw()
	local p = self:getPos()
	local x,y = p.x, p.y
	lg.setColor( 0, 0, 0, 255 )
	lg.circle( "fill", x, y, self.r )
	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "line", x, y, self.r )
end

ents.registerEntity( "ent_gravity", ENT )
