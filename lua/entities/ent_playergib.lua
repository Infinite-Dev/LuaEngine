
local ENT = {}

function ENT:setUp( x1, y1, x2, y2 )

	local poly = love.physics.newEdgeShape( x1, y1, x2, y2 )
	self:setShape( poly )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "dynamic" )
	body:setMass( 35/3 )
	body:setLinearDamping( 0.4 )
	body:setAngularDamping( 0.7 )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	fix:setDensity( 1 )
	fix:setGroupIndex( -1 )
	self:setFixture( fix )

end 

local lg = love.graphics
function ENT:draw()

	local body = self:getBody()
	lg.setColor( 255, 255, 255, 255 )

	local points = {body:getWorldPoints( self:getShape():getPoints() )}
	lg.line( unpack( points ) )

end 
ents.registerEntity( "ent_playergib", ENT )