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
  freeze = false
  state = "main"
  menu.start_main()
end

button_func.back = function()
  menu.pop()
end

button_func.toggle_fullscreen = function()
  local current_type = love.window.getFullscreen()
  love.window.setMode(screen.w, screen.h, {fullscreen = not current_type, resizable = true})
  if not current_type then
    screen.type = "Fullscreen"
  else
    screen.type = "Windowed"
  end
  window.scale_screen()
end

button_func.up_res = function()
  if not love.window.getFullscreen() then
    screen.res = screen.res + 1
    local w, h = love.window.getDesktopDimensions()
    if screen.res*screen.w > w or screen.res*screen.h > h then
      screen.res = 1
    end
    love.window.setMode(screen.res*screen.w, screen.res*screen.h, {fullscreen = false, resizable = true})
  end
end

button_func.settings = function()
  menu.push({{txt = {table = screen, index = "type"}, color = "dark_blue", img = 9, insta_func = "toggle_fullscreen"},
             {txt = {table = screen, index = "res_txt"}, color = "dark_blue", img = 10, insta_func = "up_res"},
             {txt = "Back", color = "red", img = 7, insta_func = "back"}},
             {name = "Settings", color = "blue"}, false)
end

return button_func
