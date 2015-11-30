damageInfo = {}
damageInfo.__index = damageInfo

function damageInfo.__eq(a, b)
    local dmg1 = ( type( a ) == "table" and a:getDamage() or a )
    local dmg2 = ( type( b ) == "table" and b:getDamage() or b )
    return dmg1 == dmg2 
end

function damageInfo.__lt(a, b)
    local dmg1 = ( type( a ) == "table" and a:getDamage() or a )
    local dmg2 = ( type( b ) == "table" and b:getDamage() or b )
    return dmg1 < dmg2 
end

function damageInfo.__le(a, b)
    local dmg1 = ( type( a ) == "table" and a:getDamage() or a )
    local dmg2 = ( type( b ) == "table" and b:getDamage() or b )
    return dmg1 <= dmg2 
end

function damageInfo.setDamage( self, n )
    self.damage = n 
end 

function damageInfo.getDamage( self )
    return self.damage 
end 

function damageInfo.setDamageForce( self, n )
    self.damageForce = n 
end 

function damageInfo.getDamageForce( self )
    return self.damageForce 
end 

function damageInfo.setDamageDirection( self, vec )
    self.damageDir = vec 
end 

function damageInfo.getDamageDirection( self )
    return self.damageDir
end

DMG_BULLET = 1
DMG_EXPLOSION = 2
DMG_FIRE = 3 
function damageInfo.setDamageType( self, n )
    self.damageType = n 
end 

function damageInfo.getDamageType( self )
    return self.damageType 
end

function damageInfo.scaleDamage( self, n )
    self:setDamage( self:getDamage()*n )
end 

local emptyTable = 
{
    damage = 0,
    damageForce = 0,
    damageType = DMG_BULLET,
    damageDir = vector( 0, 0 )
}
function damageInfo.new(x, y)
    return setmetatable( table.copy( emptyTable ), damageInfo)
end

setmetatable(damageInfo, { __call = function(_, ...) return damageInfo.new(...) end })