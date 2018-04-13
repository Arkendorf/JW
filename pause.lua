local pause = {}

local button = 1
local buttons = {{txt = "New Game", color = {64, 51, 102}, pos = 0}, {txt = "Load Game", color = {64, 51, 102}, pos = 0}, {txt = "Quit", color = {204, 40, 40}}, pos = 0}
local pos = -298
local on = true

pause.load = function()
  canvas.pause = love.graphics.newCanvas(244, 298)
end

pause.start = function()
  on = true
end

pause.update = function(dt)
  pos = graphics.zoom(on, pos, -298, 51, dt * 12)
  if math.floor(pos) <= -298 then
    state = oldstate
  end
end

pause.draw = function()
  love.graphics.setCanvas(canvas.mainmenu)
  love.graphics.clear()

  -- basic stuff

  love.graphics.draw(img.notebook)
  love.graphics.setColor(64, 51, 102)
  love.graphics.print("Paused", 129-math.floor(font:getWidth("Paused")/2), 18)

  -- -- buttons
  -- for i, v in ipairs(buttons) do
  --   if button == i then
  --     love.graphics.setColor(0, 132, 153)
  --   else
  --     love.graphics.setColor(v.color)
  --   end
  --   love.graphics.draw(img.mainicons, quad.mainicons[i], 48+math.floor(v.pos), 89+i * 32)
  --   love.graphics.print(v.txt, 80+math.floor(v.pos), 101+i * 32)
  -- end
  --
  -- love.graphics.setColor(64, 51, 102)
  -- love.graphics.print("Highscores", 130-math.floor(font:getWidth("Highscores")/2), 229) -- label box
  -- love.graphics.rectangle("line", 48, 245, 164, 32) -- draw high score box
  --
  -- love.graphics.setColor(0, 132, 204) -- first high score is color differently
  -- for i, v in ipairs(highscores) do -- draw highscores
  --   love.graphics.print(v, 66 + (i-1)*32 - math.floor(font:getHeight(tostring(v))/2), 257)
  --   love.graphics.setColor(64, 51, 102)
  -- end

  love.graphics.setColor(255, 255, 255) -- reset color
  love.graphics.setCanvas(canvas.game)
  love.graphics.draw(canvas.mainmenu, 178, math.floor(pos))
end

pause.keypressed = function(key)
  if key == "z" then
    love.event.quit()
  elseif key == "x" or key == "escape" then
    on = false
  end
end

return pause
