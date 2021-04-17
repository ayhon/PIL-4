function dotw(year, month, day)
	local now = os.time{year=year, month=(month+1), day=day}
	return os.date("!%w", now)
end

while true do
	local s = io.read("l")
	day, month, year = string.match(s,"(%d+)/(%d+)/(%d%d%d%d)")
	print(dotw(tostring(year), tostring(month), tostring(day)))
end
