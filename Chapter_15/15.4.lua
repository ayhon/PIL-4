function valid_key(k)
	return type(k) == "string" and string.match(k, "^%a")
end

function serialize(o, indent_lvl)
	local indent_lvl = indent_lvl or 0
	local indent = string.rep(string.rep(" ", indent_size),indent_lvl)
	local t = type(o)
	if t == "number" or t == "string" or 
		t == "boolean" or t == "nil" then
		io.write(string.format("%q",o))
	elseif t == "table" then
		io.write("{")
		local idx = 1
		for k, v in pairs(o) do
			io.write("\n"..indent.."  ")

			if idx ~= k then
				if not valid_key(k) then io.write("[") end
				serialize(k, indent_lvl+1)
				if not valid_key(k) then io.write("]") end
				io.write(" = ")
			else
				idx = idx + 1
			end

			serialize(v, indent_lvl+1)
			io.write(",")
		end
		io.write("\n",indent,"}")
	end
end

indent_size = 2

t = {
	x = {
		z = 3,
		[1] = 3,
		[{
			x = 1,
			v = 2,
			'Digo "[[Hola buenas!"]]',
			3,
			4,
		}] = 10,
	},
	{1,2,3,4,5,6,}
}
