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
	local c = a

	for i, v in ipairs(b) do
		for j, e in ipairs(v) do
			c[i][j] = c[i][j] + e
		end
	end

	return c
end
