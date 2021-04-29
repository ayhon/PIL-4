function filesAsArray(filename)
	local proxy = {}
	local h = assert(io.open(filename))
	local data = {}
	do
		local fin = h:seek("end")
		local idx = h:seek("set")
		while idx ~= fin do
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
		end,
		__pairs = function ()  -- TODO: I desist
			return function(_, k)
				local idx = k or 0
				if idx ~= #data then
					idx = idx+1
					return data[idx], idx
				else
					return nil
				end
			end
		end
	}

	setmetatable(proxy, mt)
	return proxy;

end
