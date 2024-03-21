
local TimerHandler = {Timers = {}}
local Timer = {}
Timer.__index = Timer

function TimerHandler:update(dt)
    for k, timer in pairs(self.Timers) do
        if timer.repeats == 0 then
            table.remove(self.Timers, k)
        else
            timer:update(dt)
        end
    end
end

function TimerHandler:new(duration, onTrigger, repeats)
    local timer = Timer:new(duration, onTrigger, repeats)
    table.insert(self.Timers, timer)
end


function Timer:kill()
    self.repeats = 0
end

function Timer:new(duration, onTrigger, repeats)
    local timer = {}
    timer.__index = self
    setmetatable(timer, self)
    timer.progress = 0

    if repeats == nil then repeats = true end
    if repeats == false then repeats = 1 end
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
        end
        self.progress = self.progress - self.duration
    end
end

return TimerHandler
