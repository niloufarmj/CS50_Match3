push = require 'push'

WINDOW = {
    VIRTUAL_WIDTH = 350,
    VIRTUAL_HEIGHT = 200,
    WINDOW_WIDTH = 1050,
    WINDOW_HEIGHT = 600
}

local bird = {
    image = nil,
    x = 0,
    y = WINDOW.VIRTUAL_HEIGHT / 2
}

local startTime
local duration = 2

function love.load()
    bird.image = love.graphics.newImage("assets/bird.png")

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
    

    if startTime < duration then
        startTime = startTime + dt
        bird.x = WINDOW.VIRTUAL_WIDTH * (startTime / duration) - bird.image:getWidth()
    else
        bird.x = WINDOW.VIRTUAL_WIDTH - bird.image:getWidth()
    end

end

function love.draw()
    push:start()

    love.graphics.draw(bird.image, bird.x, bird.y)
    love.graphics.printf('Time: ' .. tostring(startTime), 10, 10, WINDOW.VIRTUAL_WIDTH, 'left')

    push:finish()
end