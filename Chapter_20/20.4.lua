function filesAsArray(filename)
	local proxy = {}
	local h = assert(io.open(filename))
	local data = {}
	do
		local fin = h:seek("end")
		local idx = h:seek("set")
		print("Hello")
		while idx ~= fin do
			print("Inside")
			data[idx] = h:read(1)
			idx = idx + 1
		end
	end
	
	local mt = {
		__index = function (t,k)
			return data[k]
		end,

		__newindex = function (t,k,v)
			data[k] = v
		end
	}

	setmetatable(proxy, mt)
	return proxy;

end
