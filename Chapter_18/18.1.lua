-- With state
function fromto(n,m)
	local i = n
	return function()
		if i == m then
			return nil
		else
			i = i+1
			return i-1
		end
	end
end

-- Without state
function iter(top, x)
	-- print("Arguments",top, x)
	local val = top > x+1 and x+1
	-- if val then print("Since ",top,">=",x,"then we get",val) end
	return val or nil
end

function from2(n,m)
	return iter, m, n-1
end
