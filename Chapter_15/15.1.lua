function serialize(o, indent_lvl)
	local indent_lvl = indent_lvl or 0
	local indent = string.rep(stirng.rep(" ", indent_size),indent_lvl)
	local t = type(o)
	if t == "number" or t == "string" or 
		t == "boolean" or t == "nil" then
		io.write(string.format("%q",o))
	elseif t == "table" then
		io.write("{")
		for k, v in pairs(o) do
			io.write("\n"..indent.."  ".."[")
			serialize(k, indent_lvl+1)
			io.write("] = ")
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
		}] = 10,
	}
}
