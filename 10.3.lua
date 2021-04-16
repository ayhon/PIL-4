function transliterate2(str, rules)
	return string.gsub(str, "%w", function(c)
		if type(rules[c]) == "nil" then
			return nil
		else
			return rules[c] or ""
		end
	end)
end
