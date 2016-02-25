
local ENT = {}

function ENT:_initialize()
	self:setPos( Vector( 0, 0 ) )
	self:setAngle( 0 )
	self:setHealth( 1 )
	self:setMaxHealth( 1 )
	self:setArmorType( 1 )
	self:setArmor( 0 )
	self:setArmorRatio( 0.8 )
	self:setName( self:getClass() )
	self:setDescription( self:getIndex() )
	self:setAlive( true )
	self:setDraw( true )
	self:setValid( true )
	self._npc = true 
end 

function ENT:setName( name )
	self.__name = name 
end 

function ENT:getName()
	return self.__name 
end 

function ENT:setDescription( desc )
	self.__desc = desc 
end 

function ENT:getDescription()
	return self.__desc 
end 

function ENT:spawn()
end 

function ENT:setArmor( n )
	self.__armor = n 
end 

function ENT:getArmor()
	return self.__armor 
end 

ARMOR_TYPE_FULL = 1
ARMOR_TYPE_MITIGATE = 2
function ENT:setArmorType( type )
	self.__armorType = type 
end 

function ENT:getArmorType()
	return self.__armorType 
end 

function ENT:setArmorRatio( n )
	self.__aRatio = n 
end 

function ENT:getArmorRatio()
	return self.__aRatio 
end 

ENT.__armorTable = 
{
	function( hp, armor, dmg )
		local prevArmor = armor 
		local newArmor = armor - dmg
		local diff = prevArmor - newArmor 
		if diff > 0 then 
			hp = hp - diff 
		end 
		return hp, math.max( newArmor, 0 )
	end,

	function( hp, armor, dmg, ratio )
		local aDamage = dmg*ratio 
		local hpDamage = dmg - aDamage 
		local oldArmor = armor 
		local newArmor = armor - aDamage 
		local diff = aDamage - armor 
		if diff > 0 then 
			hpDamage = hpDamage + diff 
		end 
		return (hp - hpDamage), math.max( newArmor, 0 )
	end 
}
function ENT:setArmorTable( tbl )
	self.__armorTable = tbl 
end 

function ENT:getArmorTable()
	return self.__armorTable 
end

function ENT:takeDamage( n )
	local dmg = damageInfo()
	dmg:setDamage( n )
	dmg:setDamageForce( 0 )
	self:takeDamageInfo( dmg )
end 

function ENT:takeDamageInfo( dmgInfo )

	local dmg = dmgInfo:getDamage()
	local force = dmgInfo:getDamageForce()
	local dir = dmgInfo:getDamageDirection()
	local type = dmgInfo:getDamageType()


	local dForce = dir*force 
	self:applyForce( dForce )

	local hp = self:getHealth()
	local armor = self:getArmor()
	local r = self:getArmorRatio()
	local hp, armor = self:getArmorTable()[ self:getArmorType() ]( hp, armor, dmg, r )
	self:setHealth( hp ) 
	self:setArmor( armor )
	
end 

function ENT:setBoss( b )
	self.__isBoss = b 
end 

function ENT:isBoss()
	return self.__isBoss 
end 

function ENT:setNextEvent( t )
	self.eventTimer = love.timer.getTime() + t 
end 

function ENT:getNextEventTime()
	return self.eventTimer or 0 
end 

function ENT:setEventTable( tbl )
	self.eTable = tbl 
end 

function ENT:getEventTable()
	return self.eTable 
end 
	
function ENT:doEvent( num, nextEvent )
	self:getEventTable()[ num ]( self )
	self:setNextEvent( nextEvent ) 
end 

function ENT:setEventThink( func )
	self.eventThink = func 
end 

function ENT:shouldDoEvent()
	return love.timer.getTime() > self.eventTimer
end 

function ENT:onDeath()
	self:remove()
end 

ents.registerEntity( "npc_base", ENT )