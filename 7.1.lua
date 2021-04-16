function sort_file(filename)
	print(filename)
	-- read
	local f = io.input()
	if filename then f = io.open(filename, "r") end

	local lines = {}
	for line in f:lines() do
		table.insert(lines, line)
	end
	f:close()
	--

	-- sort
	table.sort(lines)
	--

	-- write
	f = io.output()
	if filename then f = io.open(filename, "w") end

	for _, line in ipairs(lines) do
		f:write(line, "\n")
	end
	f:close()
	--
end

sort_file((arg or {})[1])
