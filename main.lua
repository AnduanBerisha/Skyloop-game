local jet
local background
local jetX, jetY
local jetSize = 64
local speed = 280
local scroll = 0

function love.load()
    love.window.setTitle("Skyloop")
    love.window.setMode(800, 600)

    jet = love.graphics.newImage("assets/player.png")
    background = love.graphics.newImage("assets/background.jpeg")

    jetX = love.graphics.getWidth() / 2
    jetY = love.graphics.getHeight() * 0.75
end

function love.update(dt)
    local dx, dy = 0, 0

    if love.keyboard.isDown("left", "a") then dx = dx - 1 end
    if love.keyboard.isDown("right", "d") then dx = dx + 1 end
    if love.keyboard.isDown("up", "w") then dy = dy - 1 end
    if love.keyboard.isDown("down", "s") then dy = dy + 1 end

    jetX = jetX + dx * speed * dt
    jetY = jetY + dy * speed * dt

    jetX = math.max(jetSize / 2, math.min(love.graphics.getWidth() - jetSize / 2, jetX))
    jetY = math.max(jetSize / 2, math.min(love.graphics.getHeight() - jetSize / 2, jetY))

    local scale = love.graphics.getWidth() / background:getWidth()
    local tileHeight = background:getHeight() * scale
    scroll = (scroll - 150 * dt) % tileHeight
end

function love.draw()
    local scale = love.graphics.getWidth() / background:getWidth()
    local tileHeight = background:getHeight() * scale
    local y = -scroll

    while y < love.graphics.getHeight() do
        love.graphics.draw(background, 0, y, 0, scale, scale)
        y = y + tileHeight
    end

    local scaleJet = jetSize / math.max(jet:getWidth(), jet:getHeight())
    love.graphics.draw(
        jet,
        jetX, jetY,
        0,
        scaleJet, scaleJet,
        jet:getWidth() / 2, jet:getHeight() / 2
    )
end
