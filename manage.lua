local manage = {}
local table_to_string = require "tabletostring"

manage.load = function()
  if love.filesystem.exists("highscores.txt") then
    highscores = {}
    for line in love.filesystem.lines("highscores.txt") do
      table.insert(highscores, tonumber(line))
    end
  else
    love.filesystem.write("highscores.txt", "0\n0\n0\n0\n0")
    highscores = {0, 0, 0, 0, 0}
  end
end

manage.load_file = function()
  local file = love.filesystem.load("save.lua")
  local result = file()
end

manage.save_game = function()
  if state == "game" or oldstate == "game" then
    table.remove(map.path, #map.path) -- prevent cheese
  end
  love.filesystem.write("save.lua", "map.seed = "..tostring(map.seed)
  .."; money = "..tostring(money)
  .."; map.path = "..table_to_string(map.path)
  .."; char = "..table_to_string(char)
  .."; char_info = "..table_to_string(char_info))
end

manage.score = function()
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

manage.game_over = function()
  love.filesystem.remove("save.lua")
  money = 0
  bossfight.active = false
end

return manage
