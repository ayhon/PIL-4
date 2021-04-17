-- [[
-- Describe 4 ways to make an unconditional loop
-- ]]
for i = 0, 1, -1 do
end

while true do -- Prefer this one
end

repeat
until false

::redo:: do
	goto redo
end
