CountDownState = Class{__includes = BaseState}

function CountDownState:init()
  self.timer = 4

end

function CountDownState:update(dt)
  self.timer = self.timer - dt

  if self.timer <= 1 then
    gStateMachine:change('play')
  end

end

function CountDownState:render()

  love.graphics.setFont(hugeFont)
  love.graphics.printf(tostring(self.timer - (self.timer % 1)), 0, 64, VIRTUAL_WIDTH, 'center')

end