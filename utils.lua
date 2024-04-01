local utils = { showDebug = true }

function utils:start()
    self.showDebug = true
    love.window.setVSync(0)
end

function utils:stop()
    self.showDebug = false
    love.window.setVSync(1)
    print("stopping")
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
    x = x / length
    y = y / length
    if newLength then
        x = x * newLength
        y = y * newLength
    end
    return x, y
end

return utils
