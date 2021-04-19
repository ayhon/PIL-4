function listNew()
	return {first = 0, last = -1}
end

function isEmpty(list)
	return list.first > list.last
end

function pushFirst(list, value)
	list.first = list.first - 1
	list[list.first] = value
end

function pushLast(list, value)
	list.last = list.last + 1
	list[list.last] = value
end

function popFirst(list)
	if isEmpty(list) then error("list is empty") end

	local value = list[list.first]
	list[list.first] = nil -- allow garbage collection
	list.first = list.first + 1

	if isEmpty(list) then
		list.first = 0
		list.last = -1
	end

	return value
end

function popLast(list)
	if isEmpty(list) then error("list is empty") end

	local value = list[list.last]
	list[list.last] = nil
	list.last = list.last - 1

	if isEmpty(list) then
		list.first = 0
		list.last = -1
	end

	return value
end
