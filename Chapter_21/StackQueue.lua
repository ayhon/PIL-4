local Stack = require "Stack"
local StackQueue = Stack:new()

function StackQueue:new()
	o = {first_ = 1}
	self.__index = self
	return setmetatable(o, self)
end

function StackQueue:pop()
	local rv =  self.data_[self.last_]
	self.data_[self.last_] = nil
	self.last_ = self.last_ - 1
	return rv
end

function isempty()
	return self.first_ > self.last_
end

function StackQueue:insertbottom(elem)
	self.first_ = self.first_-1
	self.data_[self.first_] = elem
	return self
end

function StackQueue:__tostring()
	local v = {}
	for idx = self.first_, self.last_ + 1 do
		v[#v+1] = self.data_[idx]
	end
	return "{" .. table.concat(v, ", ") .. "}"
end

return StackQueue
