function printArray(arr)
	for k, v in pairs(arr) do
		io.write(string.format("%s: %v, ",k,v))
	end
	print()
end
