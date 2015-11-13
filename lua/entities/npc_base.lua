
local ENT = {}

function _E:_initialize()
	self:setPos( Vector( 0, 0 ) )
	self:setAngle( 0 )
	self.__health = 1
	self.__maxhealth = 1
	self.__armorType = 1 
end 

function ENT:spawn()

end 

function ENT:setHealth( hp )
	self.__health = hp 
end 

function ENT:setMaxHealth( max )
	self.__maxhealth = max 
end 

function ENT:getHealth()
	return self.__health 
end 

function ENT:getMaxHealth()
	return self.__maxhealth 
end 

function ENT:getHealthPercentage()
	return self:getHealth()/self:getMaxHealth()
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
	local hp = self:getHealth()
	local armor = self:getArmor()
	local r = self:getArmorRatio()
	local hp, armor = self:getArmorTable()[ self:getArmorType() ]( hp, armor, r )
	self:setHealth( hp ) 
	self:setArmor( armor ) 
	if self.health <= 0 then 
		self:doDeath()
	end 
end 

function ENT:setBoss( b )
	self.__isBoss = b 
end 

function ENT:isBoss()
	return self.__isBoss 
end 

function ENT:setEventTable( tbl )
	self.eTable = tbl 
end 
	
function ENT:doEvent( num, nextEvent )
	self.eTable[ num ]( self )
	self:setNextEvent( nextEvent ) 
end 

function ENT:setEventThink( func )
	self.eventThink = func 
end 

function ENT:doDeath()
	self:remove()
	self:onDeath()
end 

function ENT:onDeath()
end



ents.registerEntity( "npc_base", ENT )