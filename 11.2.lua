local counter = {}

for line in io.lines() do
	for word in string.gmatch(line, "%w+") do
		counter[word] = (counter[word] or 0) + 1
	end
end

local words = {}

for w in pairs(counter) do
	words[#words+1] = w
end

table.sort(words, function (w1, w2)
	return counter[w1] > counter[w2] or
		   counter[w1] == counter[w2] and w1 < w2
end)

local n = math.min(tonumber(arg[1]) or math.huge, #words)

function load_taboo(filename)
	local taboo = {}
	local f = assert(io.open(filename))
	local s = f:read("l")

	repeat
		for match in string.gmatch(s, "%S*") do
			-- print(match)
			taboo[match] = true
		end
		s = f:read("l")
	until not s

	return taboo
end


io.write("\nTOP "..n.." PALABRAS MÁS USADAS EN EL TEXTO DE MÁS DE 4 LETRAS:\n")

local idx, i = 1, 1

taboo = load_taboo(arg[2])
-- print(table.unpack(taboo))

while i < n do
	if not taboo[words[idx]] and #words[idx] >= 4 then
		io.write(words[idx], "\t", counter[words[idx]], "\n")
		i = i+1
	end
	idx = idx + 1
end
