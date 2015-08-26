util = {}
function util.isInArea( x, y, x2, y2, w, h )
	 if x >= x2 and x <= x2 + w and y >= y2 and y <= y2+h then
		return true
	 end
return false
end 