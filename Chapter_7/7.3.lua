function copy_to_output(amount,inp, out)
	-- TODO: Fix and test
	for line in inp:lines(amount) do
		out:write(line)
	end
end

copy_to_output(tonumber(arg[1]),io.input(), io.output())
