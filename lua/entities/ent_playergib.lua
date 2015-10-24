
local ENT = {}

function ENT:setUp( x1, y1, x2, y2, xpos, ypos )

	local poly = love.physics.newEdgeShape( x1, y1, x2, y2 )
	self:setShape( poly )

	local x,y = self:getPos()
	local body = love.physics.newBody( game.getWorld(), xpos, ypos, "dynamic" )
	body:setMass( 5 )
	body:setLinearDamping( 0.4 )
	body:setAngularDamping( 0.5 )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	fix:setRestitution( 1 )
	fix:setFriction( 0 )
	fix:setDensity( 1 )
	fix:setCategory( 3 )
	fix:setMask( 3 )
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