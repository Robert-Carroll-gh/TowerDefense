local GraphicHandler = { Graphics = {} }
local Graphic = {
    x = 0,
    y = 0,
}
Graphic.__index = Graphic

function Graphic:new(g)
    g = g or {}
    self.__index = self
    setmetatable(g, self)

    return g
end

function GraphicHandler:new(g)
    local graphic = Graphic:new(g)
    table.insert(self.Graphics, graphic)
    return graphic
end

function GraphicHandler:flashCircle(x, y, radius, color)
    local circle = { x = x or 0, y = y or 0, radius = radius or 100, color = color or { 1, 1, 1 } }
    circle.draw = function(self)
        love.graphics.setColor(color)
        love.graphics.circle("fill", self.x, self.y, self.radius)
    end
    World.timerHandler:new(0.25, function()
        circle.kill = true
    end, false)
    return self:new(circle)
end

function Graphic:draw()
    error "default graphic draw function"
end

function GraphicHandler:update(dt)
    for i = #self.Graphics, 1, -1 do
        local graphic = self.Graphics[i]
        if graphic.kill then
            table.remove(self.Graphics, i)
        elseif graphic.update ~= nil then
            graphic:update(dt)
        end
    end
end

function GraphicHandler:draw()
    for _, graphic in pairs(self.Graphics) do
        graphic:draw()
    end
end

return GraphicHandler