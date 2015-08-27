
local ENT = {}

function ENT:initialize()
	self.r = math.random( 20, 30 )
	self:newCircleShape( self.r )
	local body = self:getBody()
	body:setType( "dynamic" )
	body:applyForce( 1, 0 )
end 

local lg = love.graphics
function ENT:draw()
	local x,y = self:getNumPos()
	lg.setColor( 255, 255, 255, 255 )
	lg.circle( "line", x, y, self.r )
end 

ents.registerEntity( "ent_asteroids", ENT )