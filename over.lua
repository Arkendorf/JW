local over = {}

local button = 1
local buttons = {{txt = "New Game", color = {64, 51, 102}, pos = 0, img = 1},
                 {txt = "Return to Menu", color = {64, 51, 102}, pos = 0, img = 5},
                 {txt = "Quit", color = {204, 40, 40}, pos = 0, img = 3}}
local pos = -298
local on = true
local wait = 0

over.start = function()
  oldstate = "game"
  freeze = true
  mainmenu.score()
  mainmenu.game_over()
  wait = 0.2

  on = true
  pos = -298
  button = 1
end

over.load = function()
  canvas.pause = love.graphics.newCanvas(244, 298)
end

over.update = function(dt)
  for i, v in ipairs(buttons) do
    v.pos = graphics.zoom(button == i, v.pos, 0, 32, dt * 12)
  end
  if wait <= 0 then
    pos = graphics.zoom(on, pos, -298, 51, dt * 12)
  else
    wait = wait - dt
  end
  if on == false and math.floor(pos) <= -298 then
    if button == 1 then
      map.start()
      state = "map"
    elseif button == 2 then
      state = "main"
      mainmenu.start()
    end
    freeze = false
  end
end

over.draw = function()
  love.graphics.setCanvas(canvas.mainmenu)
  love.graphics.clear()

  -- basic stuff

  love.graphics.draw(img.notebook)
  love.graphics.setColor(204, 40, 40)
  love.graphics.print("Game Over", 129-math.floor(font:getWidth("Game Over")/2), 24)

  -- score
  love.graphics.setColor(64, 51, 102)
  love.graphics.print("Final Score", 129-math.floor(font:getWidth("Final Score")/2), 229)
  love.graphics.rectangle("line", 48, 245, 164, 32) -- draw high score box
  love.graphics.print(#map.path-2, 129-math.floor(font:getWidth(tostring(#map.path-2))/2), 257)

  -- buttons
  for i, v in ipairs(buttons) do
    if button == i then
      love.graphics.setColor(0, 132, 204)
    else
      love.graphics.setColor(v.color)
    end
    love.graphics.draw(img.mainicons, quad.mainicons[v.img], 48+math.floor(v.pos), 68+i * 32)
    love.graphics.print(v.txt, 80+math.floor(v.pos), 80+i * 32)
  end

  love.graphics.setColor(255, 255, 255) -- reset color
  love.graphics.setCanvas(canvas.game)
  love.graphics.draw(canvas.mainmenu, 178, math.floor(pos))
end

over.keypressed = function(key)
  if on == true then
    if key == "up" and button > 1 then
      button = button - 1
    elseif key == "down" and button < 3 then
      button = button + 1
    elseif key == "z" then
      if button == 1 or button == 2 then
        on = false
      elseif button == 3 then
        love.event.quit()
      end
    elseif key == "x" then
      button = 2
      on = false
    end
  end
end

return over
