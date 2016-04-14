-- GemHunt: Messages

Messages = class()

function Messages:init()
    self.gemCount = 0
    self.flagCount = 0
    self.won = false
    self.lost = false
    self.over = false
    self:setMessages()
    -- print("Messages init")
end

function Messages:setMessages()
    self.countMessage = "Value of Found Gems this Game: 0"
    self.resultMessage = "Flag Total: "
end

function Messages:setCount(c)
    self.gemCount = c
    self.countMessage = "Value of Found Gems: "..tostring(self.gemCount).." coins"
end

function Messages:setFlagCount(flags)
    self.flagCount = flags
    self.resultMessage = "Flag Total: "..tostring(self.flagCount)
end

function Messages:setResult(result)
    if result then
        self.won = true
        self.resultMessage = "Congratulations! You found all the gems!"
        if not self.over then
            self:addGems()
        end
    else
        self.lost = true
        self.resultMessage = "Oops! You're done!"
        self.gemCount = 0
    end
    self.gemMessage = "You have "..math.floor(readLocalData("GemCount", 0)).." Coins all together."
    self.over = true
end

function Messages:addGems()
    local prevGems = readLocalData("GemCount", 0)
    prevGems = prevGems + self.gemCount
    saveLocalData("GemCount", prevGems)
end

function Messages:draw()
    pushMatrix()
    pushStyle()
    
    translate(WIDTH/2, HEIGHT - 100)
    
    font("ArialRoundedMTBold")
    noStroke()
    fontSize(20)
       
    textWrapWidth(WIDTH)
    textAlign(CENTER)
    
    fill(245, 255, 0, 255)
    text(self.countMessage, 0, 0)
    
    if self.won then
        fill(32, 149, 44, 255)
        text(self.resultMessage, 0, 50)
        text(self.gemMessage, 0, 30)
    elseif self.lost then
        fill(255, 26, 0, 255)
        text(self.resultMessage, 0, 50)
        text(self.gemMessage, 0, 30)
    else
        fill(255, 128, 0, 255)
        text(self.resultMessage, 0, 50)
    end
    
    popStyle()
    popMatrix()
end

function Messages:explanations(c)
    print("Blue Gems: touching 1 booby trap (worth 5 coins)")
    print("Green Gems: touching 2 booby traps (worth 10 coins)")
    print("Orange Gems: touching 3 booby traps (worth 15 coins)")
    print("2 Greens: touching 4, etc")
    
    print("Hold for 2 seconds to plant and remove flags")
    
    print("My Coins: "..math.floor(c))
    print("Collect 3,000 coins to play 11 x 11 grid")
    print("Collect 10,000 coins to play 13 x 13 grid")
end

