

GameOverState = Class{__includes = BaseState}

function GameOverState:init()

end

function GameOverState:enter(params)
    self.score = params.score 
end

function GameOverState:update(dt)
    
end

function GameOverState:render()
end