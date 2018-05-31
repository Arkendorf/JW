local button_func = {}

button_func.new_game = function()
  map.new()
  state = "map"
end

button_func.load_game = function()
  manage.load_file()
  map.start()
  state = "map"
end

button_func.tutorial = function()
  tutorial.start()
  state = "game"
end

button_func.check_save = function()
  if love.filesystem.exists("save.lua") then
    on = false
  end
end

button_func.quit_game = function()
  love.event.quit()
end

button_func.resume = function()
  state = oldstate
  oldstate = ""
  freeze = false
end

button_func.main_menu = function()
  state = "main"
  menu.start_main()
end

return button_func
