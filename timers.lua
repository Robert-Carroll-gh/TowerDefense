---# Provides an object to create and handle Timers
--- @see Timer

---@class TimerHandler
---@field Timers Timer[] The internal list of all timers
---@field draw function call this method in love.draw <br>draws all timers
---@field update function call this method in love.update <br>updates all timers
local TimerHandler = { Timers = {} }

---@class Timer
---@field duration number time in seconds required before the timer triggers
---@field onTrigger function the function that gets called when the timer triggers
---@field repeats (boolean | integer)? repetition behavior
local Timer = {}
Timer.__index = Timer

function TimerHandler:update(dt)
    for i = #self.Timers, 1, -1 do
        timer = self.Timers[i]
        if timer.kill then
            table.remove(self.Timers, i)
        else
            timer:update(dt)
        end
    end
end

--- Not a constructor for TimerHandler
--- Constructs a Timer and adds it to the handler's internal list
---@param duration number # time in seconds required before the timer triggers
---@param onTrigger function # the function that gets called when the timer triggers
---@param repeats (boolean | integer)? # number of repetitions. false = 1, True or nil = infinity
---@return Timer
function TimerHandler:new(duration, onTrigger, repeats)
    local timer = Timer:new(duration, onTrigger, repeats)
    table.insert(self.Timers, timer)
    return timer
end

---Creates a Timer
---@param duration number # time in seconds required before the timer triggers
---@param onTrigger function # the function that gets called when the timer triggers
---@param repeats (boolean | integer)? # number of repetitions. false = 1, True or nil = infinity
---@return Timer
function Timer:new(duration, onTrigger, repeats)
    local timer = {}
    timer.__index = self
    setmetatable(timer, self)
    timer.progress = 0

    if repeats == nil then
        repeats = true
    end
    if repeats == false then
        repeats = 1
    end
    timer.duration = duration
    timer.onTrigger = onTrigger
    timer.repeats = repeats

    return timer
end

function Timer:update(dt)
    self.progress = self.progress + dt
    if self.progress >= self.duration then
        pcall(self.onTrigger)
        if type(self.repeats) == "number" then
            self.repeats = self.repeats - 1
            if self.repeats == 0 then
                self.kill = true
            end
        end
        self.progress = self.progress - self.duration
    end
end

return TimerHandler
