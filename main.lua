push = require 'push'
Timer = require 'knife.timer'

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

function love.load()
    birdImage = love.graphics.newImage("assets/bird.png")
    endX = WINDOW.VIRTUAL_WIDTH - birdImage:getWidth()

    for i = 1, numBirds do
        local bird = {
            x = 0,
            y = love.math.random(WINDOW.VIRTUAL_HEIGHT),
            speed =  math.random() + math.random(endTime - 1),
            opacity = 0
        }
        table.insert(birds, bird)
    end

    for k, bird in pairs(birds) do
        Timer.tween(bird.speed, {
            -- tween bird's X to endX over bird.rate seconds
            [bird] = { x = endX, opacity = 255}
        })
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
    Timer.update(dt)
end

function love.draw()
    push:start()

    for _, bird in ipairs(birds) do
        love.graphics.setColor(0, 255, 255, bird.opacity)
        love.graphics.draw(birdImage, bird.x, bird.y)
    end

    --love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Time: ' .. string.format("%.2f", startTime), 10, 10, WINDOW.VIRTUAL_WIDTH, 'left')

    push:finish()
end