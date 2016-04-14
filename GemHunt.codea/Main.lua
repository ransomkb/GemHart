-- GemHunt: Main

supportedOrientations(PORTRAIT_ANY)
function setup()
    displayMode(FULLSCREEN)
    gameOn = true
    goodTouch = false
    flagging = false
    controls = false
    thousand = false
    fiveThou = false
    name = "Gems"
    size = 9
    gridSize = 1
    maxSize = 1
    timer = 0
    touchX = 0
    touchY = 0
    selected = 0
    
    coins = readLocalData("GemCount", 0)
    hasCoins()
    
    -- parameter.boolean("Sound", true, hasSound)
    
    messages = Messages()
    messages:setMessages()
    messages:explanations(coins)
    startOver()
end

function draw() 
    background(0, 203, 255, 255)
    
    sprite("Documents:GemX", WIDTH - 25, HEIGHT - 25)
    sprite("Documents:BabyResetL", 25, HEIGHT - 25)
    
    if controls then
        displayMode(OVERLAY)
    else
        displayMode(FULLSCREEN_NO_BUTTONS)
    end
    
    timer = timer + DeltaTime
    
    messages:setFlagCount(chestGrid.flagCount)
    messages:setCount(chestGrid.gemCount)
    if not gameOn then
        messages:setResult(chestGrid.won)
    end
    messages:draw()
    
    camPos = vec2(WIDTH/2, HEIGHT/2)
    
    translate(camPos.x, camPos.y)
    
    for x = 0,16 do
        for y = 0,14 do
            pos = vec2(x*50 - 50*8, y*60 - 60*8)
            sprite("Planet Cute:Grass Block", pos.x, pos.y, 50)
        end
    end
    
    chestGrid:draw()
    
    if timer > 1.0 and timer < 2.0 and flagging then
        handleSelected(selected)
        isFlagging()
    end
end

function touched(touch)
    if touch.state == BEGAN then
        timer = 0
        quickie = false
        flagging = true
        touchX = touch.x
        touchY = touch.y
        selected = getTouch()
    elseif touch.state == ENDED then
        flagging = false
        if timer < 1 then
            quickie = true
            handleSelected(selected)
        end
    end
end

function isFlagging()
    if flagging then
        flagging = false
    end
end

function getTouch()
    if touchX > gridLeft and touchX < gridRight and
        touchY > gridBottom and touchY < gridTop then
            column = math.floor((touchX - gridLeft)/50) + 1
            row = math.floor((touchY - gridBottom)/60) + 1
        
            goodTouch = true
            return size*(row-1) + column
    end
    
    goodTouch = false
    
    if touchY > HEIGHT - 50 and touchX > WIDTH - 50 then
        controls = not controls
    elseif not controls and touchY > HEIGHT - 50 and touchX < 50 then
        if chestGrid.gameOver then
            startOver()
        elseif gridSize >= maxSize then
            gridSize = 1
        else
            gridSize = gridSize + 1
        end
        resize()
    end
    
    return 0
end

function handleSelected(selected)
    if goodTouch then
        if quickie then
            if gameOn then
                chestGrid:openOne(selected)
                chestGrid:isOver()
            end
                    
            if chestGrid.gameOver then
                if not chestGrid.won then
                    chestGrid:showMines()
                end
                gameOn = false
            end
        else
            chestGrid:flagOne(selected)
        end
    end
end

function resize()
    if gridSize == 1 then
        size = 9
    elseif gridSize == 2 then
        size = 11
    elseif gridSize == 3 then
        size = 13
    end
    
    startOver()
end

function startOver()
    gameOn = true
    messages = Messages()
    chestGrid = ChestGrid()
    chestGrid.size = size
    chestGrid:hideMines()
    chestGrid:createGrid()
    chestGrid.gemCount = 0
    chestGrid:countTotalGems()
    
    gridWidth = size*50
    gridHeight = size*60
    
    gridLeft = WIDTH/2 - gridWidth/2
    gridRight = WIDTH/2 + gridWidth/2
    gridTop = HEIGHT/2 + gridHeight/2
    gridBottom = HEIGHT/2 - gridHeight/2
end

function hasCoins()
    if coins >= 3000 then
        thousand = true
    else
        thousand = false
    end
        
    if coins >= 10000 then
        fiveThou = true
    else
        fiveThou = false
    end
    
    if fiveThou then
        maxSize = 3
    elseif not fiveThou and thousand then
        maxSize = 2
    else
        maxSize = 1
    end
end

function hasSound()
    if Sound then
        
    end
end
