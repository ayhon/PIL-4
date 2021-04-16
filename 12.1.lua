function in_a_mont(year, month, day)
	local now = os.time{year=year, month=(month+1), day=day}
	return os.date("!*t", now)
	
end

while true do
	local s = io.read("l")
	day, month, year = string.match(s,"(%d+)/(%d+)/(%d%d%d%d)")
	date = in_a_mont(tostring(year), tostring(month), tostring(day))
	print(os.date("%c", os.time(date)))
end
