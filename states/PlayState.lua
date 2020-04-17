PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.bird = Bird()
  self.pipePairs = {}
  self.timer = 0

  self.frequency = math.random(2, 5)

  self.score = 0

  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gSounds['pause']:play()
    gPaused = not gPaused
  end

  if not gPaused then

    -- Update the timer
    self.timer = (self.timer + dt)

    if (self.timer > self.frequency) then
      -- Spawn pipe

      -- Clamp the values.
      local y = math.max(-PIPE_HEIGHT + 10,
        math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
      self.lastY = y

      table.insert(self.pipePairs, PipePair(y))
      self.frequency = math.random(2, 5)
      self.timer = 0
    end

    -- Update the bird.
    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
      pair:update(dt)

      for l, pipe in pairs(pair.pipes) do
        if self.bird:collides(pipe) then
          -- Reset if the bird touches the pipes
          gSounds['explosion']:play()
          gSounds['hurt']:play()
          gStateMachine:change('score', {
            score = self.score
          })
        end
      end

      if not pair.scored and self.bird.x > pair.x + pair.width then
        -- The bird has passed this pair of pipes
        gSounds['score']:play()
        self.score = self.score + 1
        pair.scored = true
      end

      if (pair.remove) then
        -- Remove the pipe pair
        table.remove(self.pipePairs, k)
      end
    end

    if self.bird.y >= VIRTUAL_HEIGHT - self.bird.height then
      -- Reset if the bird touches the ground.
      gSounds['explosion']:play()
      gSounds['hurt']:play()
      gStateMachine:change('score', {
        score = self.score
      })
    end
  end

end

function PlayState:render()
  
  for k, pair in pairs(self.pipePairs) do
    pair:render()
  end

  self.bird:render()

  love.graphics.setFont(flappyFont)
  if not gPaused then
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
  else
    love.graphics.printf('Paused!', 0, 64, VIRTUAL_WIDTH, 'center')
  end

end