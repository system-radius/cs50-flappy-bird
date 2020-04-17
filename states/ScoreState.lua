ScoreState = Class{__includes = BaseState}

local medal = {}
local hasMedal = true
local medalPath = false

function ScoreState:enter(params)
  self.score = params.score

  -- Assume that the player has a medal
  hasMedal = true

  if self.score >= 10 then
    medalPath = 'gold'
  elseif self.score >= 5 then
    medalPath = 'silver'
  elseif self.score >= 3 then
    medalPath = 'bronze'
  else
    -- Too bad, the player did not earn a medal.
    hasMedal = false
  end

  if hasMedal then
    medal = love.graphics.newImage('res/img/' .. medalPath .. '.png')
  end

end

function ScoreState:update(dt)
  
  if love.keyboard.wasPressed('enter') or
      love.keyboard.wasPressed('return') then
    gStateMachine:change('count')
  end

end

function ScoreState:render()

  love.graphics.setFont(flappyFont)
  love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

  if hasMedal then
    -- Render the player's medal
    love.graphics.draw(medal, VIRTUAL_WIDTH / 2 - 16, VIRTUAL_HEIGHT / 2 - 16)
    love.graphics.printf('Congratulations! You earned a '
      ..  medalPath .. ' medal!', 0, 180, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to restart!', 0, 200, VIRTUAL_WIDTH, 'center')

  else
    love.graphics.printf('Press Enter to restart!', 0, 150, VIRTUAL_WIDTH, 'center')
  end

end