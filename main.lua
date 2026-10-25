local jet
local background
local jetX, jetY

local jetSize = 64
local speed = 280
local scroll = 0

local asteroidImages = {}
local asteroids = {}
local spawnTimer = 0
local score = 0

local gameOver = false

local function spawnAsteroid()
    local image = asteroidImages[love.math.random(#asteroidImages)]
    local size = love.math.random(40, 75)
    local scale = size / math.max(image:getWidth(), image:getHeight())

    table.insert(asteroids, {
        image = image,
        x = love.math.random(size, love.graphics.getWidth() - size),
        y = -size,
        size = size,
        scale = scale,
        speed = love.math.random(100, 180),
        rotation = love.math.random() * math.pi * 2,
        rotationSpeed = (love.math.random() - 0.5) * 2
    })
end

function love.keypressed(key)
    if key == "space" and gameOver then
        gameOver = false
        score = 0
        asteroids = {}
        spawnTimer = 0
        jetX = love.graphics.getWidth() / 2
        jetY = love.graphics.getHeight() * 0.75
    end
end


function love.load()
    love.window.setTitle("Skyloop")
    love.window.setMode(800, 600)

    jet = love.graphics.newImage("assets/player.png")
    background = love.graphics.newImage("assets/background.jpeg")

    scoreFont = love.graphics.newFont(28)

    for i = 1, 6 do
        asteroidImages[i] = love.graphics.newImage(
            "assets/asteroids/asteroid" .. i .. ".png"
        )
    end

    jetX = love.graphics.getWidth() / 2
    jetY = love.graphics.getHeight() * 0.75
end

function love.update(dt)
    if gameOver then return end

    local dx, dy = 0, 0

    if love.keyboard.isDown("left", "a") then dx = dx - 1 end
    if love.keyboard.isDown("right", "d") then dx = dx + 1 end
    if love.keyboard.isDown("up", "w") then dy = dy - 1 end
    if love.keyboard.isDown("down", "s") then dy = dy + 1 end

    jetX = jetX + dx * speed * dt
    jetY = jetY + dy * speed * dt

    jetX = math.max(jetSize / 2, math.min(love.graphics.getWidth() - jetSize / 2, jetX))
    jetY = math.max(jetSize / 2, math.min(love.graphics.getHeight() - jetSize / 2, jetY))

    local backgroundScale = love.graphics.getWidth() / background:getWidth()
    local tileHeight = background:getHeight() * backgroundScale

    scroll = (scroll + 150 * dt) % tileHeight

    spawnTimer = spawnTimer + dt

    if spawnTimer >= 0.8 then
        spawnAsteroid()
        spawnTimer = 0
    end

    for i = #asteroids, 1, -1 do
        local asteroid = asteroids[i]
        local dx = jetX - asteroid.x
        local dy = jetY - asteroid.y
        local distance = math.sqrt(dx * dx + dy * dy)

        asteroid.y = asteroid.y + asteroid.speed * dt
        asteroid.rotation = asteroid.rotation + asteroid.rotationSpeed * dt

        if distance < (jetSize + asteroid.size) * 0.35 then
            gameOver = true
        end

        if asteroid.y > love.graphics.getHeight() + asteroid.size then
            score = score + 1
            table.remove(asteroids, i)
        end
    end
end

function love.draw()
    local backgroundScale = love.graphics.getWidth() / background:getWidth()
    local tileHeight = background:getHeight() * backgroundScale
    local y = -scroll

    while y < love.graphics.getHeight() do
        love.graphics.draw(background, 0, y, 0, backgroundScale, backgroundScale)
        y = y + tileHeight
    end

    for _, asteroid in ipairs(asteroids) do
        love.graphics.draw(
            asteroid.image,
            asteroid.x,
            asteroid.y,
            asteroid.rotation,
            asteroid.scale,
            asteroid.scale,
            asteroid.image:getWidth() / 2,
            asteroid.image:getHeight() / 2
        )
    end

    local jetScale = jetSize / math.max(jet:getWidth(), jet:getHeight())

    love.graphics.draw(
        jet,
        jetX,
        jetY,
        0,
        jetScale,
        jetScale,
        jet:getWidth() / 2,
        jet:getHeight() / 2
    )

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score : " .. score, 20, 20)

    if gameOver then
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(
            "GAME OVER",
            0,
            love.graphics.getHeight() / 2 - 20,
            love.graphics.getWidth(),
            "center"
        )
        love.graphics.printf("Press SPACE to restart", 0, love.graphics.getHeight() / 2 + 20, love.graphics.getWidth(), "center")
        love.graphics.setColor(1, 1, 1)
    end

end
