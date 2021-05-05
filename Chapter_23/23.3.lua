-- Just make the items you store tables 
-- with the string you want

function str2str(s)
	return s
end

memo = {}
setmetatable(memo, {__mode = "v"})
function memorized_str2str(s)
	local res = memo[s]
	if not res then
		res = str2str(s)
		memo[s] = {data = s}
	else
		res = res.data
	end
	return res
end


