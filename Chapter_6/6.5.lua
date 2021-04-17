function combinations(ls, n) 
	local rv = {}
	if 0 < n and n <= #ls then 
		if n == 1 then
			for _, i in ipairs(ls) do
				table.insert(rv,{i})
			end
		else
			-- Solve for #ls-1, n
			local newLs = {select(2,table.unpack(ls))}
			for _, i in ipairs( combinations(newLs,n)) do
				table.insert(rv, i)
			end
			for _, i in ipairs( combinations(newLs,n-1)) do
				table.insert(i, 1, ls[1])
				table.insert(rv, i)
			end
		end

	end

	return rv
end

function pAllComb(ls)
	for k = 1, #ls do 
		for _,v in ipairs(combinations(ls, k)) do
			for i, c in ipairs(v) do
				if i == #v then
					io.write(c.."\n")
				else
					io.write(c..", ")
				end
			end
		end
	end
end

function pprint(t) print(table.unpack(t)) end
ls = {0,1,2,4,5,6,7,8,9}
