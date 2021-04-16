function n_last_line(filename,_n)
	local count = _n or 1
	local f = assert(io.open(filename,"r"))
	
	local idx = f:seek("end")
	local lines, byte = {}, nil
	for i = 1, count do
		local line
		while (byte ~= '\n' or not line) and  idx > 0 do
			idx = idx - 1
			f:seek("set",idx)
			byte = f:read(1)

			if byte == '\n' then 
				line = f:read("*L")
			end
		end
		table.insert(lines,line)
	end

	for i = #lines, 1, -1 do
		io.write(lines[i],'\n')
	end
end

n_last_line(arg[1], tonumber(arg[2]))
