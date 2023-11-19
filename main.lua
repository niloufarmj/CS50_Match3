push = require 'push'
timer = require 'knife.timer'

WINDOW = {
    VIRTUAL_WIDTH = 350,
    VIRTUAL_HEIGHT = 200,
    WINDOW_WIDTH = 1050,
    WINDOW_HEIGHT = 600
}

local timers = {
    { interval = 1, currentSecond = 0 },
    { interval = 2, currentSecond = 0 },
    { interval = 3, currentSecond = 0 },
    { interval = 4, currentSecond = 0 },
    { interval = 5, currentSecond = 0 }
}

function love.load()
    push:setupScreen(WINDOW.VIRTUAL_WIDTH, WINDOW.VIRTUAL_HEIGHT, WINDOW.WINDOW_WIDTH, WINDOW.WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    for _, t in ipairs(timers) do
        timer.every(t.interval, function() t.currentSecond = t.currentSecond + 1 end)
    end
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
    timer.update(dt)
end

function love.draw()
    push:start()
    for i, t in ipairs(timers) do
        local offsetY = (i - 1) * 18
        love.graphics.printf('Timer (' .. tostring(t.interval) .. ' seconds): ' .. tostring(t.currentSecond) .. ' seconds',
            0, WINDOW.VIRTUAL_HEIGHT / 2 - 36 + offsetY, WINDOW.VIRTUAL_WIDTH, 'center')
    end
    push:finish()
end