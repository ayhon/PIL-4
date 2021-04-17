-- -- Creo que no funciona pues no se matchea dos veces el mismo caracter
-- function split(str, delim)
-- 	local rv = {}
-- 	local pattern = delim.."(.-)"..delim

-- 	local init = string.match(str, "^(.-)"..delim)
-- 	print(init)
-- 	table.insert(rv, init)

-- 	for match in string.gmatch(str, pattern) do
-- 		print(match)
-- 		table.insert(rv, match)
-- 	end

-- 	local fini = string.match(str, delim.."(.-)$")
-- 	print(fini)
-- 	table.insert(rv, fini)

-- 	return rv
-- end

-- Excludes multiple delimiters as 1
function split(str, delim)
	delim = delim or " "
	str = delim .. str .. delim
	local rv = {}

	local pattern = "%f[^"..delim.."](.-)%f["..delim.."]"
	for match in string.gmatch(str, pattern) do
		print(match)
		table.insert(rv, match)
	end

	return rv
end

-- Includes "" when more than 1 delimiter is used
function split2(str, delim)
	delim = delim or  " "
	res = {}
	string.gsub(str, "([^"..delim.."]*)", function(elem)
		res[#res + 1] = elem
		return nil -- Inferred
	end)
	return res
end
