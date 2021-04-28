local Set = {}
local mt = {}

function Set.new (l)
	local set = {}
	setmetatable(set, mt)
	for _, v in ipairs(l) do set[v] = true end
	return set
end

function Set.union(a, b)
	local res = Set.new()
	for k in pairs(a) do res[k] = true end
	for k in pairs(b) do res[k] = true end
	return res
end

function Set.intersection(a,b)
	local res = Set.new()
	for k in pairs(a) do res[k] = b[k] end
	return res
end

function Set.tostring(set)
	local l = {}
	for e in pairs(set) do
		l[#l+1] = tostring(e)
	end
	return "{" .. table.concat(l, ", ") .. "}"
end

mt.__add = Set.union
mt.__mul = Set.intersection
mt.__tostring = Set.tostring
function mt.__sub(a, b)
	local res = Set.new()
	for k in pairs(a) do res[k] = ~b[k] end
	return res
end

function mt.__len(a)
	local res = 0
	for k in pairs(a) do res = res + 1 end
	return res
end

return Set
