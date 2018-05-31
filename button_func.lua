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

button_func.back = function()
  menu.pop()
end

button_func.toggle_fullscreen = function()
  love.window.setMode(600, 400,{fullscreen = not love.window.getFullscreen(), resizable = true})
  window.scale_screen()
end

button_func.settings = function()
  menu.push({{txt = "Fullscreen", color = "dark_blue", img = 4, insta_func = "toggle_fullscreen"},
             {txt = "Resolution", color = "dark_blue", img = 5, insta_func = "main_menu"},
             {txt = "Back", color = "red", img = 7, insta_func = "back"}},
             {name = "Settings", color = "blue"}, false)
end

return button_func
