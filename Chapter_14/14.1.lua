a = {
	{nil, 1, nil},
	{nil, 1, nil},
	{nil, 1, nil}
}

b = {
	{1, nil,   1},
	{1, nil,   1},
	{1, nil, nil}
}

function add(a, b)
	local c = {}
	for i, v in pairs(b) do
		local c_i = {}
		for j, e in pairs(v) do
			c_i[j] = (c_i[j] or 0) + e
		end
		c[i] = c_i
	end

	for i, v in pairs(a) do
		for j, e in pairs(v) do
			c[i][j] = (c[i][j] or 0) + e
		end
	end

	-- pprint(c)
	return c
end

function pprint(t)
	for i, v in pairs(t) do
		io.write(i,"|")
		for j, e in pairs(v) do
			io.write(j,": ",e,"  ")
		end
		io.write("\n")
	end
end
