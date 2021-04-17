ls = {18,28,38,48,58,68,78,8,9}

function shuffle(list, _ini, _fin)
	local newList = {}
	local ini = _ini or 1
	local fin = _fin or #list

	while (fin >= ini) do
		idx = math.random(fin-ini+1)
		-- print("Index:",idx," Value:",list[idx])
		item = table.remove(list, idx)
		table.insert(list, item)
		-- list:insert(list:remove(idx)) -- No funciona, no se por qué
		-- printt(list)
		fin = fin - 1
	end
	list = newList
	-- printt(list)
end

function printt(t)
	print(table.unpack(t))
end
