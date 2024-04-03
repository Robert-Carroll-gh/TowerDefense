local world = { { "a" }, { "b" }, { "c" } } -- world
local world = {} -- system

local show = function(t)
    for k, v in pairs(t) do
        print(k)
        print(k.id)
        print(v)
    end
end
