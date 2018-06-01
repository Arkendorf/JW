button_func = require "button_func"

local menu = {}

local menus = {}

local button = 1

local pos = 400
local on = true

local button_y = 40

menu.off = function()
  on = false
end

menu.get_button = function()
  return menus[1].buttons[button]
end

menu.format_buttons = function(table)
  local buttons = {}
  for i, v in ipairs(table) do -- format buttons
    buttons[i] = {txt = v.txt, img = v.img, func = v.func, color = palette[v.color], pos = 0}
    if v.insta_func then
      buttons[i].insta_func = v.insta_func
    end
  end
  return buttons
end

menu.start = function(table1, table2, score)
  state = "menu"
  on = true
  pos = 400

  menus = {}
  menu.push(table1, table2, score)
end

menu.push = function(table1, table2, score)
  local buttons = menu.format_buttons(table1)
  table.insert(menus, 1, {buttons = buttons, title = table2, highscore = score})
  if menus[1].title.name == "Flioneer" then
    button_y = 86
  else
    button_y = 36
  end
  button = 1
end

menu.pop = function()
  table.remove(menus, 1)
  if menus[1].title.name == "Flioneer" then
    button_y = 86
  else
    button_y = 36
  end
  button = 1
end

menu.load = function()
  canvas.clipboard = love.graphics.newCanvas(244, 298)
end

menu.update = function(dt)
  for i, v in ipairs(menus[1].buttons) do
    v.pos = graphics.zoom(button == i, v.pos, 0, 32, dt * 12)
  end

  pos = graphics.zoom(not on, pos, 51, 400, dt * 12)
  if pos < 51 then
    pos = 51
  elseif math.ceil(pos) >= 400 and not on and menus[1].buttons[button].func then
    button_func[menus[1].buttons[button].func]()
  end
end

menu.draw = function()
  love.graphics.setCanvas(canvas.clipboard)
  love.graphics.clear()

  -- basic stuff
  love.graphics.draw(img.notebook)
  if menus[1].title.name == "Flioneer" then
    love.graphics.draw(img.title, 26, 18)
  else
    love.graphics.setColor(palette[menus[1].title.color])
    love.graphics.print(menus[1].title.name, 129-math.floor(font:getWidth(menus[1].title.name)/2), 24)
  end

  -- buttons
  for i, v in ipairs(menus[1].buttons) do
    if button == i then
      love.graphics.setColor(palette.blue)
    else
      love.graphics.setColor(v.color)
    end
    love.graphics.draw(img.mainicons, quad.mainicons[v.img], 48+math.floor(v.pos), button_y + i * 32)
    if type(v.txt) == "string" then
      love.graphics.print(v.txt, 80+math.floor(v.pos), button_y+12 + i * 32)
    else
      love.graphics.print(tostring(v.txt.table[v.txt.index]), 80+math.floor(v.pos), button_y+12 + i * 32)
    end
  end

  love.graphics.setColor(palette.navy)
  love.graphics.rectangle("line", 48, 262, 164, 16) -- draw high score box

  if menus[1].highscore then -- draw score/highscore
    love.graphics.print("Highscores", 129-math.floor(font:getWidth("Highscores")/2), 249) -- label box
    love.graphics.setColor(palette.blue) -- first high score is color differently
    for i, v in ipairs(highscores) do -- draw highscores
      love.graphics.print(v, 66 + (i-1)*32 - math.floor(font:getHeight(tostring(v))/2), 266)
      love.graphics.setColor(palette.navy)
    end
  else
    love.graphics.print("Score", 129-math.floor(font:getWidth("Score")/2), 249)
    if #map.path > 1 then
      love.graphics.print(#map.path-2, 129-math.floor(font:getWidth(tostring(#map.path-2))/2), 266)
    else
      love.graphics.print(0, 129-math.floor(font:getWidth("0")/2), 266)
    end
  end

  love.graphics.setColor(255, 255, 255) -- reset color
  love.graphics.setCanvas(canvas.menu)

  love.graphics.draw(canvas.clipboard, 178, math.floor(pos))

  love.graphics.setCanvas()
end

menu.keypressed = function(key)
  if on == true then
    if key == "up" and button > 1 then
      button = button - 1
    elseif key == "down" and button < #menus[1].buttons then
      button = button + 1
    elseif key == "z" then
      if menus[1].buttons[button].insta_func then
        button_func[menus[1].buttons[button].insta_func]()
      else
        on = false
      end
    end
  end
end

menu.start_main = function()
  menu.start({{txt = "New Game", color = "dark_blue", img = 1, insta_func = "overwrite", func = "new_game"},
              {txt = "Load Game", color = "dark_blue", img = 2, insta_func = "check_save", func = "load_game"},
              {txt = "Tutorial", color = "dark_blue", img = 6, insta_func = "overwrite", func = "tutorial"},
              {txt = "Quit", color = "red", img = 3, insta_func = "quit_game"}},
              {name = "Flioneer", color = "blue"}, true)
end

menu.start_over = function()
  menu.start({{txt = "New Game", color = "dark_blue", img = 1, func = "new_game"},
              {txt = "Return to Menu", color = "dark_blue", img = 5, func = "main_menu"},
              {txt = "Quit", color = "red", img = 3, insta_func = "quit_game"}},
              {name = "Game Over", color = "red"}, false)
end

menu.start_pause = function()
  freeze = true
  menu.start({{txt = "Resume", color = "dark_blue", img = 4, func = "resume"},
              {txt = "Save to Menu", color = "dark_blue", img = 5, func = "main_menu"},
              {txt = "Settings", color = "dark_blue", img = 8, insta_func = "settings"},
              {txt = "Save and Quit", color = "red", img = 3, insta_func = "quit_game"}},
              {name = "Paused", color = "blue"}, false)
end

menu.end_pause = function()
  button = 1
  on = false
end

return menu
