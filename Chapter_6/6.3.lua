function allbutlast(...)
	return table.unpack({...},1,select("#",...)-1)
end
