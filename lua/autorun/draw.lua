draw = {}

local lg = love.graphics
local rad = math.pi*2

-- r should not be greater than the w or h of the rectangle.
function draw.roundedRect( x, y, w, h, r, m, s )

    r = r or 14
    m = m or "fill"
    s = s or 10

    lg.rectangle( m, x + r, y + r, w - r*2, h - r*2 )
    lg.arc( m, x + r, y + r, r, -rad*0.5, -rad*0.25, s )
    lg.arc( m, x + w - r, y + r, r, 0, -rad*0.25, s )
    lg.arc( m, x + r, y + h - r, r, -rad*0.5, -rad*0.75, s )
    lg.arc( m, x + w - r, y + h - r, r, -rad*0.75, -rad, s )

    lg.rectangle( m, x + r, y, w - r*2, r )
    lg.rectangle( m, x, y + r, r, h - r*2 )
    lg.rectangle( m, x + w - r, y + r, r, h - r*2 )
    lg.rectangle( m, x + r, y + h - r, w - r*2, r )

end
