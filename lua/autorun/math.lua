
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

function math.easeInOut( fProgress, fEaseIn, fEaseOut ) 

	if (fEaseIn == nil) then fEaseIn = 0 end
	if (fEaseOut == nil) then fEaseOut = 1 end

	local fSumEase = fEaseIn + fEaseOut; 

	if( fProgress == 0.0 or fProgress == 1.0 ) then return fProgress end

	if( fSumEase == 0.0 ) then return fProgress end
	if( fSumEase > 1.0 ) then
		fEaseIn = fEaseIn / fSumEase; 
		fEaseOut = fEaseOut / fSumEase; 
	end

	local fProgressCalc = 1.0 / (2.0 - fEaseIn - fEaseOut); 

	if( fProgress < fEaseIn ) then
		return ((fProgressCalc / fEaseIn) * fProgress * fProgress); 
	elseif( fProgress < 1.0 - fEaseOut ) then
		return (fProgressCalc * (2.0 * fProgress - fEaseIn)); 
	else 
		fProgress = 1.0 - fProgress; 
		return (1.0 - (fProgressCalc / fEaseOut) * fProgress * fProgress); 
	end
end

function math.loop( num, min, max, incr )
	num = num + ( incr or 1 )
	if num > max then 
		num = min 
	end 
	return num 
end 

function math.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end