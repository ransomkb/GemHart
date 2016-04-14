-- GemHunt: Gem

Gem = class()

function Gem:init(x, y, col, size, val)
    self.position = vec2(x,y)
    self.size = size or 100
    self.type = "Planet Cute:Gem Blue"
    self.col = col or 1
    self.value = val or 0
    -- blue = 5; green = 10; orange = 15
    
    self:selectColor()
end

function Gem:selectColor()
    if self.col == 1 then
        self.type = "Planet Cute:Gem Blue"
    elseif self.col == 2 then
        self.type = "Planet Cute:Gem Green"
    elseif self.col == 3 then
        self.type = "Planet Cute:Gem Orange"
    elseif self.col == 4 then
        self.type = "Tyrian Remastered:Mine Spiked Huge"
    elseif self.col == 5 then
        self.type = "Small World:Explosion"
    end
end

function Gem:draw()
    sprite(self.type, self.position.x, self.position.y, self.size)
end

