-- GemHunt: Chest

Chest = class()

function Chest:init(x)
    self.gems = {}
    self.neighbors = {}
    self.name = x
    self.pos = vec2(0,0)
    self.gridSize = 9
    self.size = 50
    self.image = "Planet Cute:Chest Closed"
    self.hasSound = true
    self.gameOver = false
    self.touched = false
    self.justTouched = false
    self.flag = false
    self.flagSize = 25
    self.open = false
    self.danger = false
    self.dangerLevel = 0
    self.gemCount = 0
    
    self.textColor = vec3(0,0,0)
    
    self.flagSp = Flag()
end

function Chest:draw()
    pushMatrix()
    
    translate(self.pos.x, self.pos.y)
    
    self:isOpen()
    
    sprite(self.image, 0, 0, self.size)
    
    
    if self.open or self.gameOver then
        for i,g in ipairs(self.gems) do
            g:draw()
        end
    end
    if self.danger then
        fill(255, 132, 0, 255)
    else
        fill(self.textColor.x, self.textColor.y, self.textColor.z, 255)
    end
    popMatrix()
end

function Chest:plantFlag()
    self.flagSp = Flag()
    
    tween(0.3, self.flagSp, {size = 25, rota = 720})
end

function Chest:cleanUp()
    tween.resetAll()
    self.flagSp = Flag(25)
end

function Chest:pullFlag()
    self.flagSp = Flag()
    
    local f1 = tween(2.0, self.flagSp, {size = 100, rota = 720})
    local f2 = tween(2.0, self.flagSp, {size = 200, rota = 720})
    tween.sequence(f1, f2)
    self:flipFlag()
end

function Chest:flipFlag()
    self.flag = not self.flag
end

function Chest:flagSound()
    if self.flag and self.hasSound then
        sound(SOUND_HIT, 23434)
    end
end

function Chest:isOpen()
    if self.open then
        self.image = "Planet Cute:Chest Open"
    end
end

function Chest:opened()
    if self.danger then
        self.gems = {Gem(0, 30, 5, 90)}
        self.gameOver = true
        if self.hasSound then  
            sound(SOUND_HIT, 23419)
        end
    else 
        if self.hasSound then  
            sound(SOUND_HIT, 17345)
        end
    end
end

function Chest:isCorner()
    local n = self.name
    if n == 1 then
        self.neighbors = {n+1, n+self.gridSize, n+self.gridSize+1}
        return true
    elseif n == self.gridSize then
        self.neighbors = {n-1, n+self.gridSize, n+self.gridSize-1}
        return true
    elseif n == (self.gridSize*self.gridSize - self.gridSize + 1) then
        self.neighbors = {n+1, n-self.gridSize, n-self.gridSize+1}
        return true
    elseif n == self.gridSize*self.gridSize then
        self.neighbors = {n-1, n-self.gridSize, n-self.gridSize-1}
        return true
    end
    
    return false
end

function Chest:isEdge()
    n = self.name
    rSide = {}
    lSide = {}
    
    if n > 1 and n < self.gridSize then
        self.neighbors = {n-1, n+1, n+self.gridSize-1, n+self.gridSize, n+self.gridSize+1}
        return true
    elseif n > (self.gridSize*self.gridSize-self.gridSize+1) and n < (self.gridSize*self.gridSize) then
        self.neighbors = {n-1, n+1, n-self.gridSize-1, n-self.gridSize, n-self.gridSize+1}
        return true
    end
    
    self:fillSides()
    if self:isSide(rSide) then
        self.neighbors = {n-1, n-self.gridSize, n-self.gridSize-1, n+self.gridSize, n+self.gridSize-1}
        return true
    elseif self:isSide(lSide) then
        self.textColor.x = 255
        self.neighbors = {n+1, n+self.gridSize, n+self.gridSize+1, n-self.gridSize, n-self.gridSize+1}
        return true
    end
    
    return false
end

function Chest:isSide(side)
    for i,v in ipairs(side) do
        if v == self.name then
            return true
        end
    end
    return false
end

function Chest:fillSides()
    for i = 2, (self.gridSize-1) do
        table.insert(rSide, i*self.gridSize)
        table.insert(lSide, i*self.gridSize-self.gridSize+1)
    end
end

function Chest:fillNeighbors()
    local n = self.name
    if self:isCorner() then
        self.textColor.x = 255
        return
    elseif self:isEdge() then
        self.textColor.y = 255
        return
    end
    
    self.textColor.z = 255
    self.neighbors = {n-1, n+1, n-(self.gridSize-1), n+(self.gridSize-1), n-self.gridSize, n+self.gridSize, n-(self.gridSize+1), n+(self.gridSize+1)}
end

function Chest:checkDangerLevel(m)
    for i,n in ipairs(self.neighbors) do
        if not self.danger and n == m then
            self.dangerLevel = self.dangerLevel + 1
        end
    end
end

function Chest:printDangerLevel()
    if self.danger then
        self.image = "Planet Cute:Chest Open"
    end
end

function Chest:fillChest()
    if self.danger then
        self.gems = {Gem(0, 0, 4, 30)}
    elseif self.dangerLevel == 1 then
        self.gems = {Gem(0, 0, 1, 20, 5)}
    elseif self.dangerLevel == 2 then
        self.gems = {Gem(0, 0, 2, 20, 10)}
    elseif self.dangerLevel == 3 then
        self.gems = {Gem(0, 0, 3, 20, 15)}
    elseif self.dangerLevel == 4 then
        self.gems = {Gem(-10, 0, 2, 20, 10), Gem(10, 0, 2, 20, 10)}
    elseif self.dangerLevel == 5 then
        self.gems = {Gem(-10, 0, 2, 20, 10), Gem(10, 0, 3, 20, 15)}
    elseif self.dangerLevel == 6 then
        self.gems = {Gem(-10, 0, 3, 20, 15), Gem(10, 0, 3, 20, 15)}
    elseif self.dangerLevel == 7 then
        self.gems = {Gem(-10, 0, 3, 15, 15), Gem(10, 0, 3, 15, 15), Gem(0, 10, 1, 15, 5)}
    elseif self.dangerLevel == 8 then
        self.gems = {Gem(-10, 0, 3, 15, 15), Gem(10, 0, 3, 15, 15), Gem(0, 10, 2, 15, 10)}
    end
    
    self.gemCount = self.dangerLevel*5
end

