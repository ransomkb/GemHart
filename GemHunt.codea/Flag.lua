Flag = class()

function Flag:init(x)
    self.size = x or 100
    self.rota = 0
end

function Flag:draw()
    rotate(self.rota)
    sprite("Small World:Flag", 0, 0, self.size)
end

