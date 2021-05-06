function comb(elems, k, n, rv)
	n = n or #elems
	rv = rv or {}

	if  #rv == k then coroutine.yield(rv)
	elseif n < k then return
	else
		-- try with nth element
		rv[#rv+1] = elems[n]
		comb(elems, k-1, n-1, rv)
		rv[#rv+1] = nil

		-- try without nth element
		comb(elems, k-1, n, rv)
	end
end

function combinations(l, k) 
	local co = coroutine.create(function() comb(l,k) end)
	return function()
		local status, comb = coroutine.resume(co)
		return comb
	end
end

v = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"}

-- TODO: Debug
