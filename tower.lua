Tower = {
    x = 0,
    y = 0,
    width = 50,
    height = 50,
    color = {0.3,0.3,0.3},
    fireRate = 1, -- shots per second
    damage = 1, -- damage per shot  

}

function Tower:new(x,y)
    local t = {}
    self.__index = self
    setmetatable(t, self)
    t.x, t.y = x, y

    return t
end

function Tower:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",
        self.x - self.width / 2,
        self.y - self.height / 2,
        self.width, self.height)
end

