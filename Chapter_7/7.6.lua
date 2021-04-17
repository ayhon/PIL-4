function create_directory(name)
	os.execute("mkdir "..name)
end
function remove_directory(name)
	os.execute("rmdir "..name)
end
function list_files_in(dir)
	local command = "ls ".. (dir or ".")
	os.execute(command)
	-- local f = os.popen(command,"r")
	-- for line in f:lines() do
	-- 	io.write(line, '\n')
	-- end
end
