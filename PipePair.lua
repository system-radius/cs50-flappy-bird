PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y)
  
  self.x = VIRTUAL_WIDTH + 32
  self.y = y

  self.width = PIPE_WIDTH

  -- We should not be concerned with the height.

  self.pipes = {
    ['upper'] = Pipe('top', self.y),
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + math.random(GAP_HEIGHT, GAP_HEIGHT + 30))
  }

  self.remove = false
  self.scored = false

end

function PipePair:update(dt)

  if self.x < -PIPE_WIDTH then

    self.remove = true
  else

    self.x = self.x - PIPE_SPEED * dt
    self.pipes['upper'].x = self.x
    self.pipes['lower'].x = self.x

  end

end



function PipePair:render()

  for key, pipe in pairs(self.pipes) do
    pipe:render()
  end

end