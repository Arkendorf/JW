local mainmenu = {}
local table_to_string = require "tabletostring"

local button = 1

mainmenu.load = function()
end

mainmenu.update = function(dt)
end

mainmenu.draw = function()
  love.graphics.print("New Game", 48, 0)
  love.graphics.print("Load Game", 48, 12)
  love.graphics.print("Quit", 48, 24)
  love.graphics.rectangle("fill", 34, -12 + button*12, 12, 12)
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

return mainmenu
