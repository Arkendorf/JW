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
  if state == "map" then
    map.start()
  elseif state == "reward" then
    reward.create_canvases()
  end
end

manage.load_settings = function()
  local file = love.filesystem.load("settings.lua")
  local result = file()
  love.window.setMode(screen.res*screen.w, screen.res*screen.h, {fullscreen = (screen.type == "Fullscreen"), resizable = true}) -- update screen size based on saved settings
  window.scale_screen()
end

manage.save_game = function()
  local save_string = -- basic info (always necessar [ish])
  "map.seed = "..tostring(map.seed)
  .."; state = '"..oldstate.."'"
  .."; money = "..tostring(money)
  .."; map.path = "..table_to_string(map.path)
  .."; char = "..table_to_string(char)
  .."; char_info = "..table_to_string(char_info)

  if oldstate == "game" then -- game stuff
    save_string = save_string
    .."; level_score = "..table_to_string(level_score)
    .."; stats = "..table_to_string(stats)
    .."; level.scroll = "..table_to_string(level.scroll)
    .."; tier_max = "..tostring(tier_max)
    .."; spawn_delay = "..tostring(spawn_delay)
    .."; level_reward = "..tostring(level_reward)
    .."; enemies = "..table_to_string(enemies)
    .."; bullets = "..table_to_string(bullets)
    .."; drops = "..table_to_string(drops)

    if bossfight.active then -- if bossfight is happening, save that info
      save_string = save_string
      .."bossfight = "..table_to_string(bossfight)
    end
  elseif oldstate == "reward" then
    for i, v in ipairs(items) do
      v.canvas = nil
    end
    save_string = save_string
    .."; reward_num = "..tostring(reward_num)
    .."; reward_type = '"..reward_type.."'"
    .."; items = "..table_to_string(items)
    .."; stats = "..table_to_string(stats)
    .."; total_score = "..tostring(total_score)
    .."; tier_max = "..tostring(tier_max)
  end

  love.filesystem.write("save.lua", save_string)
end

manage.save_settings = function()
  love.filesystem.write("settings.lua", "screen.type = '"..screen.type.."'"
  .."; screen.res = '"..tostring(screen.res).."'")
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
