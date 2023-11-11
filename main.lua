

push = require 'push'


WINDOW = {
    VIRTUAL_WIDTH = 350,
    VIRTUAL_HEIGHT = 200,
    WINDOW_WIDTH = 1050,
    WINDOW_HEIGHT = 600
}

local currentSecond = 0
local secondTimer = 0


function love.load()
    push:setupScreen(WINDOW.VIRTUAL_WIDTH, WINDOW.VIRTUAL_HEIGHT, WINDOW.WINDOW_WIDTH, WINDOW.WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
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
    secondTimer = secondTimer + dt
    
    if secondTimer >= 1 then
        currentSecond = currentSecond + 1
        secondTimer = 0
    end
    
end

function love.draw()
    push:start()
    love.graphics.printf('Timer: ' .. tostring(currentSecond) .. ' seconds',
        0, WINDOW.VIRTUAL_HEIGHT / 2 - 6, WINDOW.VIRTUAL_WIDTH, 'center')
    push:finish()
end