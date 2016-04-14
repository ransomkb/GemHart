-- GemHunt: ChestGrid

ChestGrid = class()

function ChestGrid:init()
    self.aTouch = vec2(0,0)
    self.gameOver = false
    self.won = false
    self.size = 9
    self.blown = 0
    self.gemCount = 0
    self.totalGems = 0
    self.flagCount = 0
    self.gemList = {}
    self.chests = {}
    self.mined = {}
    self.temp = {}
    self.checkList = {}
    self.mineList = {}
end

function ChestGrid:draw()
    for i,v in ipairs(self.chests) do
        v:draw()
    end
    
    for i,v in ipairs(self.chests) do
        if v.flag and not v.open then
            pushMatrix()
            translate(v.pos.x, v.pos.y)
            v.flagSp:draw()
            popMatrix()
        end
    end
end

function ChestGrid:flagOne(selected)
    c = self.chests[selected]
    c.flagSp = Flag()
    c:flipFlag()
    if c.flag then
        self.flagCount = self.flagCount + 1
        c:plantFlag()
    elseif self.flagCount > 0 and not c.flag then
        self.flagCount = self.flagCount - 1
    end
end

function ChestGrid:openOne(selected)
    c = self.chests[selected]
    c:opened()
    c.open = true
    c.touched = true
    if c.flag then
        self.flagCount = self.flagCount - 1
        c.flag = false
    end
    
    gc = c.gemCount
    if gc > 0 and not c.justTouched then
        table.insert(self.gemList, gc)
        self:countGemList()
    end
    c.justTouched = true
        
    if c.gameOver then
        self.gameOver = true
        self.blown = c.name
    elseif c.dangerLevel == 0 then
        for i,n in pairs(c.neighbors) do
            nc = self.chests[n]
            if nc.dangerLevel == 0 and not nc.danger then
                nc.open = true
            end
        end
    end
end

function ChestGrid:isOver()
    if self.gemCount == self.totalGems then
        self.gameOver = true
        self.won = true
    end
end

function ChestGrid:countTotalGems()
    for i, c in ipairs(self.chests) do
        if not c.danger then
            self.totalGems = self.totalGems + c.dangerLevel * 5
        end
    end
end

function ChestGrid:countGemList()
    self.gemCount = 0
    
    for i,g in pairs(self.gemList) do
        self.gemCount = self.gemCount + g
    end
end

function ChestGrid:createGrid()
    local xPos = 50
    local yPos = 60
    local sizeRatio = 5
    if self.size == 11 then 
        sizeRatio = 6
    elseif self.size == 13 then
        sizeRatio = 7
    end
    
    for x = 1, self.size do
        for y = 1, self.size do
            self:fillGrid(x+self.size*(y-1), vec2(xPos*x - xPos*sizeRatio, yPos*y - yPos*sizeRatio))
        end
    end
end

function ChestGrid:fillGrid(name, pos)
    chest = Chest(name)
    chest.gridSize = self.size
    chest:fillNeighbors()
    chest.pos = pos
    
    for i,m in ipairs(self.mineList) do
        if m == chest.name then
            chest.danger = true
            chest.dangerLevel = 0
            table.insert(self.mined, chest)
        else
            chest:checkDangerLevel(m)
        end
    end
    chest:fillChest()
    self.chests[chest.name] = chest
end

function ChestGrid:showMines()
    for i,m in ipairs(self.mined) do
        if m.danger then
            m.image = "Planet Cute:Chest Open"
            m.gameOver = true
        end
    end
end

function ChestGrid:hideMines()
    while #self.mineList < (self.size*2 - 8) do
        n = self:getRandom(self.size*self.size)
        while self:isInMineList(n) do
            n = self:getRandom(self.size*self.size)
        end
        
        table.insert(self.mineList, n)
    end
end

function ChestGrid:getRandom(s)
    return math.random(1, s)
end

function ChestGrid:isInMineList(n)
    for i,m in ipairs(self.mineList) do
        if n == m then
            return true
        end
    end
    
    return false
end

