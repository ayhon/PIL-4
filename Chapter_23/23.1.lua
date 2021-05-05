local function kv(t)
	return setmetatable(t,{__mode = "kv"})
end

local function die_with_hello(t)
	return setmetatable(t, {__gc = function() print "Hello world" end})
end

eph = kv{}
o = die_with_hello{}
eph[o] = function() return o end
o = nil
collectgarbage()
