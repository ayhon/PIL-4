function last_line(filename)
	local f = assert(io.open(filename,"r"))
	
	local idx = f:seek("end")
	local line, byte 
	while (byte ~= '\n' or not line) and  idx > 0 do
		idx = idx - 1
		f:seek("set",idx)
		byte = f:read(1)

		if byte == '\n' then 
			line = f:read("*L") 
		end
	end

	io.write(line,'\n')
end

last_line(arg[1])
