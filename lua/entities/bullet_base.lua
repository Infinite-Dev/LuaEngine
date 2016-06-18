
local ENT = {}
BULLET_DRAWMODE_CIRCLE = 1
BULLET_DRAWMODE_LINE = 2

function ENT:initialize()
	self.bulletColor = { 255, 255, 255, 255 }
	self:setDrawMode( BULLET_DRAWMODE_CIRCLE )
end

function ENT:setDrawMode( n )
	self.__drawMode = n
end

function ENT:getDrawMode()
	return self.__drawMode
end

function ENT:setDamageInfo( dmg )
	self.__dInfo = dmg
end

function ENT:getDamageInfo()
	return self.__dInfo
end

function ENT:setSize( n )
	self.r = n
	local circle = love.physics.newCircleShape( self.r )
	self:setShape( circle )

	local p = self:getPos()
	local x,y = p.x, p.y
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( 1 )
	body:setLinearDamping( 0 )
	body:setBullet( true )
	self:setBody( body )

	local d = 5
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	self:setFixture( fix )

	self.drawx = x
	self.drawy = y
end

function ENT:setThinkFunc( func )
	self.thinkFunc = func
end

function ENT:setCalLBack( func )
	self.callBack = func
end

function ENT:setBulletData( bulletData )

	local pos = bulletData.startPos
	local dir = bulletData.dir
	local speed = bulletData.speed
	local damage = bulletData.damage
	local force = bulletData.force
	local angle = bulletData.angle or 0
	local size = bulletData.size
	local callBack = bulletData.callBack
	local thinkFunc = bulletData.thinkFunc
	local owner = bulletData.owner
	local color = bulletData.color
	local paintFunc = bulletData.paintFunc
	local drawMode = bulletData.drawMode

	self:setSize( size )
	self:setPos( pos )
	self:setVelocity( dir*speed )
	self:setAngle( angle )
	self:setCollisionType( COLLISION_TYPE_BULLET )

	if thinkFunc then
		self:setThinkFunc( thinkFunc )
	end

	if callBack then
		self:setCallBack( callBack )
	end

	if owner then
		local i = owner:getGroupIndex()
		self:setGroupIndex( i )
	end

	if color then
		self.bulletColor = color
	end

	if paintFunc then
		self.draw = paintFunc
	end

	if drawMode then
		self:setDrawMode( drawMode )
	end


	local dmgInfo = damageInfo()
	dmgInfo:setDamage( damage )
	dmgInfo:setDamageForce( force )
	dmgInfo:setDamageDirection( dir )
	dmgInfo:setDamageType( DMG_BULLET )
	self:setDamageInfo( dmgInfo )

	local a = angle + math.pi/2
	local a2 = angle + math.pi*1.5
	self.xadd = math.cos( a )*self.r
	self.xadd2 = math.cos( a2 )*self.r
	self.yadd = math.sin( a )*self.r
	self.yadd2 = math.sin( a2 )*self.r

end

function ENT:collisionPreSolve( ent, coll )
	if self.callBack then
		self:callBack( ent )
	end
	ent:takeDamageInfo( self:getDamageInfo() )
	self:remove()
	coll:setEnabled( false )
end

function ENT:think()

	local p = self:getPos()
	local x,y = p.x, p.y
	local w,h = love.graphics.getDimensions()

	local compW = w*1.4
	local compH = h*1.4

	local mult = 1.2
	local compare = self.r*mult
	local x2,y2 = x + compare, y + compare
	local x3,y3 = x - compare, y - compare

	if x3 > compW + compare/2 then
		self:remove()
	elseif y3 > compH + compare/2 then
		self:remove()
	elseif x2 < -compare/2 - (compW-w) then
		self:remove()
	elseif y2 < -compare/2 - (compH-h) then
		self:remove()
	end

	if self.thinkFunc then
		self:thinkFunc()
	end

end

local math = math
local lg = love.graphics
local drawModes =
{
	function( self )
		local p = self:getPos()
		local x,y = p.x, p.y
		lg.circle( "fill", x, y, self.r )
	end,

	function( self )
		local p = self:getPos()
		local x,y = p.x, p.y
		local x1,y1 = self.xadd + x,self.yadd + y
		local x2,y2 = self.xadd2 + x,self.yadd2 + y
		lg.line( x1, y1, x2, y2 )
	end
}
function ENT:draw()

	lg.setColor( unpack( self.bulletColor ) )
	local dMode = self:getDrawMode()
	if drawModes[ dMode ] then
		drawModes[ dMode ]( self )
	else
		drawMode[ 2 ]( self )
	end

end
ents.registerEntity( "bullet_base", ENT )
