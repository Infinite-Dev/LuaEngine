
_E = {}
_E.__index = _E

function _E:_initialize()
	self:setPos( Vector( 0, 0 ) )
	self:setAngle( 0 )
	self:setHealth( 1 )
	self:setMaxHealth( 1 )
	self:setAlive( true )
	self:setDraw( true )
	self:setValid( true )
end

function _E:initialize()
end

function _E:getIndex()
	return self._index
end

function _E:getID()
	return self._id
end

function _E:draw()
	self:drawImage()
end

function _E:think()

end

function _E:touch()

end

function _E:physicsCollide()

end

function _E:setBodyType( type )
	self:getBody():setType( type )
end

function _E:generateBody( world, type )
	local x,y = self:getNumPos()
	local body = love.physics.newBody( world, x, y, type )
	self:setBody( body )
end

function _E:setBody( body )
	self.__body = body
end

function _E:getBody()
	return self.__body
end

function _E:getFixture()
	return self.__fixture
end

function _E:setFixture( fix )
	fix:setUserData( { isEntity = true, index = self:getIndex() } )
	self.__fixture = fix
end

function _E:setGroupIndex( group )
	if self:getFixture() then
		self:getFixture():setGroupIndex( group )
	end
end

function _E:getGroupIndex()
	local f = self:getFixture()
	if f then
		return f:getGroupIndex()
	end
	return 0
end

function _E:setShape( shape )
	self.__shape = shape
end

function _E:getShape()
	return self.__shape
end

function _E:setHull( width, height )
	self:newRectangleShape( width, height )
end

function _E:physWake()
	local b = self:getBody()
	b:setAwake( true )
	b:setActive( true )
end

function _E:physSleep()
	local b = self:getBody()
	b:setAwake( false )
end

function _E:setImage( img )
	if type( img ) == "image" then
		self.__image = img
	else
		self.__image = love.graphics.newImage( "sprites/"..img )
	end
end

function _E:getImage()
	return self.__image
end

function _E:drawImage()
	love.graphics.draw( self:GetImage() )
end

function _E:draw()
end

function _E:setDraw( bool )
	self.__shouldDraw = bool
end

function _E:shouldDraw()
	return self.__shouldDraw
end

function _E:setPos( vec, y )
	local p
	if y then
		p = { x = vec, y = y }
	else
		p = { x = vec.x, y = vec.y }
	end
	local body = self:getBody()
	if body then
		body:setPosition( p.x, p.y )
		self.__pos = p
	else
		self.__pos = p
	end
end

function _E:getPos()
	local body = self:getBody()
	if body then
		local x,y = body:getPosition()
		return vector( x, y )
	else
		return  vector( self.__pos.x, self.__pos.y )
	end
end

function _E:getAngle()
	local body = self:getBody()
	if body then
		return body:getAngle()
	else
		return self.__angle
	end
end

function _E:setAngle( a )
	local body = self:getBody()
	if body then
		body:setAngle( a )
		self.__angle = a
	else
		self.__angle = a
	end
end

function _E:getIndex()
	return self._index
end

function _E:getClass()
	return self._class
end

function _E:applyForce( x, y )
	local b = self:getBody()
	if b then
		if type( x ) == "table" then
			b:applyForce( x.x, x.y )
		else
			b:applyForce( x, y )
		end
	end
end

function _E:applyImpulse( x, y )
	local b = self:getBody()
	if b then
		if type( x ) == "table" then
			b:applyLinearImpulse( x.x, x.y )
		else
			b:applyLinearImpulse( x, y )
		end
	end
end

function _E:setVelocity( x, y )
	local b = self:getBody()
	if b then
		if type( x ) == "table" then
			b:setLinearVelocity( x.x, x.y )
		else
			b:setLinearVelocity( x, y )
		end
	end
end

function _E:getVelocity( asVector )
	local b = self:getBody()
	if b then
		local x,y = b:getLinearVelocity()
		return asVector and vector( x, y ) or x,y
	end
end

function _E:getBoundingBox()
	local f = self:getFixture()
	if f then
		return f:getBoundingBox()
	end
	return 1,1,1,1
end

function _E:getBoundingBoxDimensions()
	local topLeftX, topLeftY, bottomRightX, bottomRightY = self:getBoundingBox()
	local w = bottomRightX - topLeftX
	local h = bottomRightY - topLeftY
	return w, h
end

function _E:collisionPostSolve()
end

function _E:collisionPreSolve()
end

GROUPINDEX_PLAYER = -100
GROUPINDEX_BULLET = -101
GROUPINDEX_NPC  = -102
GROUPINDEX_WORLD  = -103
GROUPINDEX_ENTITY = -104


COLLISION_TYPE_PLAYER 	= 1
COLLISION_TYPE_BULLET 	= 2
COLLISION_TYPE_NPC 		= 3
COLLISION_TYPE_WORLD 	= 4
COLLISION_TYPE_ENTITY 	= 5
local collisionFuncs =
{
	[ COLLISION_TYPE_PLAYER ] = function( self )
		local f = self:getFixture()
		if f then
			f:setCategory( COLLISION_TYPE_PLAYER )
			f:setGroupIndex( GROUPINDEX_PLAYER )
		end
	end,

	[ COLLISION_TYPE_BULLET ] = function( self )
		local f = self:getFixture()
		if f then
			f:setCategory( COLLISION_TYPE_BULLET )
			f:setMask( COLLISION_TYPE_BULLET )
		end
	end,

	[ COLLISION_TYPE_NPC ] = function( self )
		local f = self:getFixture()
		if f then
			f:setCategory( COLLISION_TYPE_NPC )
			f:setGroupIndex( GROUPINDEX_NPC )
		end
	end,

	[ COLLISION_TYPE_ENTITY ] = function( self )
		local f = self:getFixture()
		if f then
			f:setCategory( COLLISION_TYPE_ENTITY )
			f:setGroupIndex( GROUPINDEX_ENTITY )
		end
	end,

	[ COLLISION_TYPE_WORLD ] = function( self )
		local f = self:getFixture()
		if f then
			f:setCategory( COLLISION_TYPE_WORLD )
			f:setGroupIndex( GROUPINDEX_WORLD )
		end
	end,
}
function _E:setCollisionType( n )
	if collisionFuncs[ n ] then
		collisionFuncs[ n ]( self )
	end
end

function _E:takeDamage( n )
	local dmg = damageInfo()
	dmg:setDamage( n )
	dmg:setDamageForce( 0 )
	self:takeDamageInfo( dmg )
end

function _E:takeDamageInfo( dmgInfo )

	if not self:isValid() then return end
	self:onTakeDamage( dmgInfo )

	local dmg = dmgInfo:getDamage()
	local force = dmgInfo:getDamageForce()
	local dir = dmgInfo:getDamageDirection()
	local type = dmgInfo:getDamageType()

	local hp = self:getHealth() - dmg

	local dForce = dir*force
	self:applyImpulse( dForce )

	self:setHealth( hp )


end

function _E:onTakeDamage( dmgInfo )
end

function _E:setHealth( hp )
	self.__health = hp
	if hp <= 0 then
		self:doDeath()
	end
end

function _E:doDeath()
	if not self:isAlive() then return end
	ents.addToDeathList( self )
	self:setAlive( false )
end

function _E:onDeath()
end

function _E:setMaxHealth( max )
	self.__maxhealth = max
end

function _E:getHealth()
	return self.__health
end

function _E:getMaxHealth()
	return self.__maxhealth
end

function _E:getHealthPercentage()
	return self:getHealth()/self:getMaxHealth()
end

function _E:isNPC()
	return self._npc
end

function _E:isAlive()
	return self.__alive
end

function _E:setAlive( bool )
	self.__alive = bool
end

function _E:onRemove()
end

function _E:isValid()
	return self.__valid
end

function _E:setValid( b )
	self.__valid = b
end

local posFuncs =
{
	function( r )
		local w,h = love.graphics.getDimensions()
		local x = love.math.random( 0, w )
		local y = -r*1.1
		return x,y
	end,
	function( r )
		local w,h = love.graphics.getDimensions()
		local x = love.math.random( 0, w )
		local y = h + r*1.1
		return x,y
	end,
	function( r )
		local w,h = love.graphics.getDimensions()
		local x = -r*1.1
		local y = love.math.random( 0, h )
		return x,y
	end,
	function( r )
		local w,h = love.graphics.getDimensions()
		local x = w + r*1.1
		local y = love.math.random( 0, h )
		return x,y
	end
}
function _E:getSpawnPos()
	local w,h = self:getBoundingBoxDimensions()
	local p = love.math.random( 1, 4 )
	local x, y = posFuncs[ p ]( p > 2 and w or h )
	return vector( x, y )
end

function _E:onSpawn()
end

function _E:setMass( m )
	local b = self:getBody()
	if b then
		b:setMass( m )
	end
end

function _E:getMass()
	local b = self:getBody()
	if b then
		return b:getMass()
	end
end

function _E:remove()
	if not self:isValid() then return end
	self:onRemove()
	local b = self:getBody()
	local f = self:getFixture()
	local s = self:getShape()

	if f then
		f:destroy()
	end

	if b then
		b:destroy()
	end

	local e = ents.getIndex()
	e[ self:getIndex() ] = nil
	self:setValid( false )
end
