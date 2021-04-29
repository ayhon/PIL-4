local Stack = {}

function Stack:new()
	o = { 
		data_ = {},
		last_ = 0
	}
	self.__index = self
	return setmetatable(o, self)
end

function Stack:push(elem)
	self.last_ = self.last_ + 1
	self.data_[self.last_] = elem
	return self
end

function Stack:pop()
	local rv = self.data_[self.last_] 
	self.data_[self.last] = nil
	return rv
end

function Stack:isempty()
	return self.last == 0
end

function Stack:__tostring()
	return "{" .. table.concat(self.data_, ", ") .. "}"
end

return Stack
