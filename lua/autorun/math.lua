
function math.distance( x1, y1, x2, y2 )
	return math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
end

function math.clamp( num, min, max )
	if num < min then
		return min 
	elseif num > max then
		return max 
	end 
	return num 
end 

function math.approach( cur, target, inc )
	inc = math.abs( inc )
	if (cur < target) then
		
		return math.clamp( cur + inc, cur, target )

	elseif (cur > target) then

		return math.clamp( cur - inc, target, cur )

	end
	return target
end 