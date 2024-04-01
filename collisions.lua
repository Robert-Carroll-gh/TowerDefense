local M = {}

M.makeColidable = function(object)
    --operate on the class if possible
    local mt = getmetatable(object)
    if mt ~= object then
        object = mt
    end

    function object:getPos()
        return self.x, self.y
    end

    if not object.shape then
        if object.radius then
            object.shape = "circle"
        elseif object.height and object.width then
            object.shape = "rectangle"
        else
            object.shape = "point"
        end
    end

    if not object.onColide then
        function object:onColide(dt, colider)
            -- code
        end
    end
end

return M
