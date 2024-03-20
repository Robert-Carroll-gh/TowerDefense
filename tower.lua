Bullet = require("bullet")

Tower = {
    x = 0,
    y = 0,
    width = 50,
    height = 50,
    color = {0.3,0.3,0.3},
    fireRate = 1, -- time between shots
    damage = 1, -- damage per shot  
    bulletType = Bullet,
    target = nil,
    shotTimer = 0,
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

function Tower:shoot(x, y)
    self.bulletType:new(self.x, self.y, x, y)
end

function Tower:update(dt)
    if self.target then
        self.shotTimer = self.shotTimer + dt
        if self.shotTimer >= self.fireRate then
            self:shoot(self.target.x, self.target.y)
        end
    end
end
