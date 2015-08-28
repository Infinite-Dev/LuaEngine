
local ENT = {}

function ENT:initialize()
	local w,h = love.graphics.getDimensions()
	self:setPos( w/2, h/2 )
	local bound = love.physics.newEdgeShape( w, 0, w, h )
	self:setShape( bound )

	local x,y = self:getNumPos()
	local body = love.physics.newBody( game.getWorld(), x, y, "static" )
	self:setBody( body )

	local d = 5 
	local fix = love.physics.newFixture( self:getBody(), self:getShape(), 1 )
	self:setFixture( fix )
end 

local lg = love.graphics
function ENT:draw()
	local x,y = self:getNumPos()
	lg.setColor( 255, 255, 255, 255 )
	--lg.polygon("line",self:getBody():getWorldPoints(self:getShape():getPoints()))
end 

ents.registerEntity( "ent_boundryright", ENT )