push = require 'push'

WINDOW = {
    VIRTUAL_WIDTH = 350,
    VIRTUAL_HEIGHT = 200,
    WINDOW_WIDTH = 1050,
    WINDOW_HEIGHT = 600
}

local currentSecond = 0
local secondTimer = 0

local currentSecond2 = 0
local secondTimer2 = 0

local currentSecond3 = 0
local secondTimer3 = 0

local currentSecond4 = 0
local secondTimer4 = 0

local currentSecond5 = 0
local secondTimer5 = 0

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
    secondTimer2 = secondTimer2 + dt
    secondTimer3 = secondTimer3 + dt
    secondTimer4 = secondTimer4 + dt
    secondTimer5 = secondTimer5 + dt
    
    if secondTimer >= 1 then
        currentSecond = currentSecond + 1
        secondTimer = 0
    end
    
    if secondTimer2 >= 2 then
        currentSecond2 = currentSecond2 + 1
        secondTimer2 = 0
    end
    
    if secondTimer3 >= 3 then
        currentSecond3 = currentSecond3 + 1
        secondTimer3 = 0
    end
    
    if secondTimer4 >= 4 then
        currentSecond4 = currentSecond4 + 1
        secondTimer4 = 0
    end
    
    if secondTimer5 >= 5 then
        currentSecond5 = currentSecond5 + 1
        secondTimer5 = 0
    end
end

function love.draw()
    push:start()
    love.graphics.printf('Timer (1 second): ' .. tostring(currentSecond) .. ' seconds',
        0, WINDOW.VIRTUAL_HEIGHT / 2 - 36, WINDOW.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Timer (2 seconds): ' .. tostring(currentSecond2) .. ' seconds',
        0, WINDOW.VIRTUAL_HEIGHT / 2 - 18, WINDOW.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Timer (3 seconds): ' .. tostring(currentSecond3) .. ' seconds',
        0, WINDOW.VIRTUAL_HEIGHT / 2, WINDOW.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Timer (4 seconds): ' .. tostring(currentSecond4) .. ' seconds',
        0, WINDOW.VIRTUAL_HEIGHT / 2 + 18, WINDOW.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Timer (5 seconds): ' .. tostring(currentSecond5) .. ' seconds',
        0, WINDOW.VIRTUAL_HEIGHT / 2 + 36, WINDOW.VIRTUAL_WIDTH, 'center')
    push:finish()
end