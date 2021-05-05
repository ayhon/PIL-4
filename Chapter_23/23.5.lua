function memory_stress_test(_lim)
	local lim = _lim or 1000
	t = {}
	for i = 1, lim do
		a = {}
		for j = 1, lim do
			b = {}
			for k = 1, lim do
				b[j] = {k}
			end
			a[j] = b
		end
		t[i] = a
	end
end

function time(f,...)
	local ini = os.clock()
	f(...)
	return os.clock() - ini
end

function test(p, s, _lim)
	local fmt = "pause: %s, stepmul: %s, time = %f"

	if p then collectgarbage("setpause", p) end
	if p then collectgarbage("setstepmul", s) end
	print(string.format(fmt, p or "NA", s or "NA", time(memory_stress_test,_lim)))
end

test(nil, 200)
test(0, 200)
test(1000, 200)
test(200, 0)
test(200, 1000000)

--[[

pause: NA, stepmul: 200, time = 444.939442
pause: 0, stepmul: 200, time = 1352.007774
pause: 1000, stepmul: 200, time = 273.585444
pause: 200, stepmul: 0, time = 314.461342
pause: 200, stepmul: 1000000, time = 524.856068

--]] --
