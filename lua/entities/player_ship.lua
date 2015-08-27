
local ENT = {}

function ENT:initialize()
	self:setBody( World, self:getX(), self:getY(), "dynamic" )
end 

ents.registerEntity( "player_ship", ENT )