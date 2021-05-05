o = {x = "hi"}
setmetatable(o, {__gc = function (o) print(o.x) end})

-- -- This calls the finalizer
-- os.exit() -- This doesn't call the finalizer
-- error("Oh no") -- This calls the finalizer, after showing the error

