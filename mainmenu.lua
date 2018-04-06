local mainmenu = {}
local table_to_string = require "tabletostring"

local button = 1

mainmenu.load = function()
  if love.filesystem.exists("highscore.txt") then
    local result = love.filesystem.read("highscore.txt")
    highscore = tonumber(result)
  else
    love.filesystem.write("highscore.txt", "0")
    highscore = 0
  end
end

mainmenu.update = function(dt)
end

mainmenu.draw = function()
  love.graphics.print("New Game", 48, 0)
  love.graphics.print("Load Game", 48, 12)
  love.graphics.print("Quit", 48, 24)
  love.graphics.rectangle("fill", 34, -12 + button*12, 12, 12)

  love.graphics.print(highscore, 300, 0)
end

mainmenu.keypressed = function(key)
  if key == "up" and button > 1 then
    button = button - 1
  elseif key == "down" and button < 3 then
    button = button + 1
  elseif key == "z" then
    if button == 1 then
      map.start()
      state = "map"
    elseif button == 2 and love.filesystem.exists("save.lua") then
      mainmenu.load_file()
      map.start()
      state = "map"
    elseif button == 3 then
      love.event.quit()
    end
  end
end

mainmenu.load_file = function()
  local file = love.filesystem.load("save.lua")
  local result = file()
end

mainmenu.save_game = function()
  love.filesystem.write("save.lua", "map.seed = "..tostring(map.seed)
  .."; money = "..tostring(money)
  .."; map.path = "..table_to_string(map.path)
  .."; char = "..table_to_string(char)
  .."; char_info = "..table_to_string(char_info))
end

mainmenu.quit = function()
  love.filesystem.remove("save.lua")
  if #map.path-2 > highscore then -- update high score
    love.filesystem.write("highscore.txt", tostring(#map.path-2))
  end
  love.event.quit()
end

return mainmenu
