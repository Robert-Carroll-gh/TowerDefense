local utils = { showDebug = false }

function utils.isPointInCenteredRec(x, y, rec)
    local minx = rec.x - rec.width / 2
    local miny = rec.y - rec.height / 2
    local maxx = rec.x + rec.width / 2
    local maxy = rec.y + rec.height / 2
    if maxx == nil or minx == nil or maxy == nil or miny == nil then
        return false
    end
    return x >= minx and x <= maxx and y >= miny and y <= maxy
end

function utils.isPointInRec(x, y, rec)
    local minx = rec.x
    local miny = rec.y
    local maxx = rec.x + rec.width
    local maxy = rec.y + rec.height
    return x >= minx and x <= maxx and y >= miny and y <= maxy
end

function utils.setAlpha(color, alpha)
    return { color[1], color[2], color[3], alpha }
end

function utils:start()
    self.showDebug = true
    love.window.setVSync(0)
end

function utils:stop()
    self.showDebug = false
    love.window.setVSync(1)
    print "stopping"
end

function utils:toggle()
    if self.showDebug then
        self:stop()
    else
        self:start()
    end
    return self.showDebug
end

---prints debug information to the game
function utils:drawDebug()
    if self.showDebug then
        love.graphics.setColor(1, 1, 1)
        local mousePositionText = "Mouse Position: X = " .. love.mouse.getX() .. " Y = " .. love.mouse.getY()
        love.graphics.print("FPS: " .. love.timer.getFPS())
        love.graphics.print(mousePositionText, 0, 12)
    end
end

function utils:debug(msg)
    local msg = msg or "debug message!"
    if self.showDebug then
        print(msg)
    end
end

---normalizes the 2d vector x,y and optionally sets a new length
---@param x number
---@param y number
---@param newLength? number
---@return number
---@return number
function utils.normalize(x, y, newLength)
    local length = math.sqrt(x ^ 2 + y ^ 2)
    if length == 0 then
        return 0, 0
    end
    x = x / length
    y = y / length
    if newLength then
        x = x * newLength
        y = y * newLength
    end
    return x, y
end
function utils.vecTo(x1, y1, x2, y2)
    return x2 - x1, y2 - y1
end
function utils.lengthSquared(x, y)
    return x ^ 2 + y ^ 2
end
function utils.length(x, y)
    return math.sqrt(utils.lengthSquared(x, y))
end
function utils.distanceSquared(x1, y1, x2, y2)
    return utils.lengthSquared(utils.vecTo(x1, y1, x2, y2))
end
function utils.distance(x1, y1, x2, y2)
    return utils.length(utils.vecTo(x1, y1, x2, y2))
end

function utils.closestObject(x, y, objectList, filter)
    local closest = nil
    local minSquare = 99999999
    filter = filter or function()
        return true
    end
    for i, object in ipairs(objectList) do
        local distance = utils.distanceSquared(x, y, object.x, object.y)
        if distance < minSquare and filter(object) then
            minSquare = distance
            closest = object
        end
    end
    return closest
end

return utils
