local mainmenu = {}
local table_to_string = require "tabletostring"

local button = 1
local buttons = {{txt = "New Game", color = {64, 51, 102}, pos = 0, img = 1},
                 {txt = "Load Game", color = {64, 51, 102}, pos = 0, img = 2},
                 {txt = "Quit", color = {204, 40, 40}, pos = 0, img = 3}}
local pos = 400
local on = true

mainmenu.start = function()
  on = true
  pos = 400
  button = 1
end

mainmenu.load = function()
  if love.filesystem.exists("highscores.txt") then
    highscores = {}
    for line in love.filesystem.lines("highscores.txt") do
      table.insert(highscores, tonumber(line))
    end
  else
    love.filesystem.write("highscores.txt", "0\n0\n0\n0\n0")
    highscores = {0, 0, 0, 0, 0}
  end

  for i, v in ipairs(buttons) do
    v.pos = 0
  end

  canvas.mainmenu = love.graphics.newCanvas(244, 298)
end

mainmenu.update = function(dt)
  for i, v in ipairs(buttons) do
    v.pos = graphics.zoom(button == i, v.pos, 0, 32, dt * 12)
  end
  pos = graphics.zoom(not on, pos, 51, 400, dt * 12)
  if pos < 51 then
    pos = 51
  elseif math.ceil(pos) >= 400 then
    if button == 1 then
      map.start()
      state = "map"
    elseif button == 2 then
      mainmenu.load_file()
      map.start()
      state = "map"
    end
  end
end

mainmenu.draw = function()
  love.graphics.setCanvas(canvas.mainmenu)
  love.graphics.clear()

  -- basic stuff
  love.graphics.draw(img.notebook)
  love.graphics.draw(img.title, 26, 18)

  -- buttons
  for i, v in ipairs(buttons) do
    if button == i then
      love.graphics.setColor(0, 132, 204)
    else
      love.graphics.setColor(v.color)
    end
    love.graphics.draw(img.mainicons, quad.mainicons[v.img], 48+math.floor(v.pos), 89+i * 32)
    love.graphics.print(v.txt, 80+math.floor(v.pos), 101+i * 32)
  end

  love.graphics.setColor(64, 51, 102)
  love.graphics.print("Highscores", 129-math.floor(font:getWidth("Highscores")/2), 229) -- label box
  love.graphics.rectangle("line", 48, 245, 164, 32) -- draw high score box

  love.graphics.setColor(0, 132, 204) -- first high score is color differently
  for i, v in ipairs(highscores) do -- draw highscores
    love.graphics.print(v, 66 + (i-1)*32 - math.floor(font:getHeight(tostring(v))/2), 257)
    love.graphics.setColor(64, 51, 102)
  end

  love.graphics.setColor(255, 255, 255) -- reset color
  love.graphics.setCanvas(canvas.game)
  love.graphics.draw(canvas.mainmenu, 178, math.floor(pos))
end

mainmenu.keypressed = function(key)
  if on == true then
    if key == "up" and button > 1 then
      button = button - 1
    elseif key == "down" and button < 3 then
      button = button + 1
    elseif key == "z" then
      if button == 1 then
        on = false
      elseif button == 2 and love.filesystem.exists("save.lua") then
        on = false
      elseif button == 3 then
        love.event.quit()
      end
    end
  end
end

mainmenu.load_file = function()
  local file = love.filesystem.load("save.lua")
  local result = file()
end

mainmenu.save_game = function()
  if #map.path > 1 then
    table.remove(map.path, #map.path) -- prevent cheese
  end
  love.filesystem.write("save.lua", "map.seed = "..tostring(map.seed)
  .."; money = "..tostring(money)
  .."; map.path = "..table_to_string(map.path)
  .."; char = "..table_to_string(char)
  .."; char_info = "..table_to_string(char_info))
end

mainmenu.score = function()
  for i, v in ipairs(highscores) do -- replace high score if new record is reached
    if #map.path-2 > v then
      for j = #highscores, i, -1 do
        highscores[j] = highscores[j-1]
      end
      highscores[i] = #map.path-2
      break
    end
  end
  local filestring = ""
  for i, v in ipairs(highscores) do -- compile highscores to write into file
    filestring = filestring .. v .. "\n"
  end
  love.filesystem.write("highscores.txt", filestring) -- write into file
end

mainmenu.game_over = function()
  love.filesystem.remove("save.lua")
end

return mainmenu
