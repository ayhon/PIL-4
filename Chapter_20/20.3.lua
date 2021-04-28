local readOnly_mt = { 
	__index = function(_,k) 
		return _.___get_data(k) 
	end,

	__newindex = function(_, k, v)
		error("Can't modify a read-only table",2)
	end

}

function readOnly(t)
	local proxy = {
		___get_data = function (k)
			return t[k]
		end
	}

	setmetatable(proxy, readOnly_mt)

	return proxy
end
