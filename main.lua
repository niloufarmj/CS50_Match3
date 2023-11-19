push = require 'push'

WINDOW = {
    VIRTUAL_WIDTH = 350,
    VIRTUAL_HEIGHT = 200,
    WINDOW_WIDTH = 1050,
    WINDOW_HEIGHT = 600
}

local birds = {}
local numBirds = 100
local startTime
local endTime = 10
local birdImage
local birdImageWidth = 30
local maxDistance = WINDOW.VIRTUAL_WIDTH - birdImageWidth
local minSpeed = maxDistance / endTime
local maxSpeed = 2 * minSpeed

function love.load()
    birdImage = love.graphics.newImage("assets/bird.png")

    for i = 1, numBirds do
        local bird = {
            x = 0,
            y = love.math.random(WINDOW.VIRTUAL_HEIGHT),
            speed = love.math.random(minSpeed, maxSpeed)
        }
        table.insert(birds, bird)
    end

    push:setupScreen(WINDOW.VIRTUAL_WIDTH, WINDOW.VIRTUAL_HEIGHT, WINDOW.WINDOW_WIDTH, WINDOW.WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    startTime = 0
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    if startTime > 10 then
        return
    end
    startTime = startTime + dt

    for _, bird in ipairs(birds) do
        bird.x = bird.speed * startTime
        if bird.x > WINDOW.VIRTUAL_WIDTH - birdImageWidth then
            bird.x = WINDOW.VIRTUAL_WIDTH - birdImageWidth
        end
    end
end

function love.draw()
    push:start()

    for _, bird in ipairs(birds) do
        love.graphics.draw(birdImage, bird.x, bird.y)
    end

    love.graphics.printf('Time: ' .. string.format("%.2f", startTime), 10, 10, WINDOW.VIRTUAL_WIDTH, 'left')

    push:finish()
end