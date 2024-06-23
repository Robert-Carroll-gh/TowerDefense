local utils = require "utils"

local noArt = love.graphics.newImage "images/noArt_32x32.png"

---@class ItemHandler
---@field Items Item[]
local ItemHandler = { Items = {} }

---@class Item
local Item = {
    x = 0,
    y = 0,
    pickedUp = false,
    usage = "none",
    attatched = false,

    radius = noArt:getHeight() / 2,
    width = noArt:getWidth(),
    height = noArt:getHeight(),
    color = { 1, 1, 1 },
}
Item.__index = Item

ItemHandler.types = require "itemTypes"
for name, item in pairs(ItemHandler.types) do
    item.__index = Item
    setmetatable(item, Item)
end

function ItemHandler:update(dt)
    for i = #self.Items, 1, -1 do
        local item = self.Items[i]
        if item.kill then
            table.remove(self.Items, i)
        elseif item.update ~= nil then
            item:update(dt)
        end
    end
end

function ItemHandler:draw()
    for _, item in pairs(self.Items) do
        if item.pickedUp == false then
            item:draw()
        end
    end
end

--- not a constructor for ItemHandler
--- constructs a Item, and adds it to the handler's list
---@param type string
---@param x number
---@param y number
---@return Item
function ItemHandler:new(type, x, y, targetX, targetY)
    local item
    if ItemHandler.types[type] ~= nil and ItemHandler.types[type] ~= "none" then
        print("newItem: " .. type)
        item = ItemHandler.types[type]:new(x, y, targetX, targetY)
    else
        item = Item:new(x, y)
    end
    table.insert(self.Items, item)
    return item
end

---Item constructor
---@param x number
---@param y number
---@return Item
function Item:new(x, y)
    local item = {}
    --ID(item)
    self.__index = self
    setmetatable(item, self)

    item.x, item.y = x, y

    return item
end

function Item:pickUp()
    assert(self.pickedUp == false)
    assert(self.attatched == false)
    self.pickedUp = true
end

function Item:update(dt)
    -- nothing yet
end

function Item:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(noArt, self.x - self.radius, self.y - self.radius)
end

return ItemHandler
