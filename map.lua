local map = {}

local map_pos = {x = 12, y = 40}
local scroll = 0
local x_pos = 0
local grid = {w = 6, h = 4, t = 64}
local target = {x = 1, y = 1}
local path = {{x = 1, y = 1}}
local options = {}
local map_seed = 0
local type_name = {"None", "Weapon", "Upgrade", "Health", "Ammo", "Money", "Shop"}

map.load = function()
  map_seed = os.time()
  math.randomseed(map_seed)

  path[1].y = math.random(1, 4)
  target.y = path[1].y

  map.find_options()

  -- create map canvases
  canvas.map = love.graphics.newCanvas(grid.w*64+64, 320)
  canvas.scroll = love.graphics.newCanvas(64, 320)
  canvas.note = love.graphics.newCanvas(80, 64)
end

map.update = function(dt)
  -- adjust position of the map
  if target.x > grid.w + x_pos then
    x_pos = x_pos + 1
  elseif target.x < x_pos+1 then
    x_pos = x_pos - 1
  end

  -- limit target y pos
  if target.y < 1 then
    target.y = 1
  elseif target.y > grid.h then
    target.y = grid.h
  end

  -- make the nice scrolling effect
  scroll = math.floor(scroll + (x_pos * grid.t - scroll) * dt * 12)
end

map.draw = function()
  love.graphics.setCanvas(canvas.map)
  love.graphics.clear()

  for i = -math.ceil(grid.w*grid.t/320/2), math.ceil(grid.w*grid.t/320/2) do
    love.graphics.draw(img.map, math.floor(-scroll % 320) + i*320, 0)
  end

  -- draw details
  for x = -2-math.ceil(grid.w/2), grid.w+2+math.ceil(grid.w/2) do
    math.randomseed(map_seed+x+x_pos)
    if (x+x_pos) % 4 == 0 then
      love.graphics.draw(img.mapdetail, quad.mapdetail[math.random(1, 12)], math.floor(x*grid.t+math.random(-grid.t, grid.t)*.33-scroll+x_pos*grid.t), math.floor(grid.t+math.random(0, (grid.h-1)*grid.t)), 0, 1, 1, 32, 32)
    end
  end

  -- draw travelled path
  love.graphics.setColor(64, 51, 102)
  for i, v in ipairs(path) do
    --get start coords
    local x1, y1 = map.get_node_coords(v.x, v.y)
    if i+1 <= #path and v.x+2 > x_pos-math.ceil(grid.w/2) and v.x-2 < x_pos+grid.w+math.ceil(grid.w/2) then
      --get new coords coords
      local x2, y2 = map.get_node_coords(path[i+1].x, path[i+1].y)

      -- now draw line
      love.graphics.line(x1-scroll, y1, x2-scroll, y2)

      -- set start coords to new coords
      x1 = x2
      y1 = y2
    end
  end

  -- draw options
  local x1, y1 = map.get_node_coords(path[#path].x, path[#path].y)
  for i, v in ipairs(options) do
    -- get coords of option
    local x2, y2 = map.get_node_coords(v.x, v.y)

    -- now draw line
    if v.x == target.x and v.y == target.y then
      -- if target is an option
      love.graphics.setColor(204, 40, 40)
      love.graphics.line(x1-scroll, y1, x2-scroll, y2)
    else
      love.graphics.setColor(64, 51, 102)
      map.dotted_line(x1-scroll, y1, x2-scroll, y2)
    end
  end
  love.graphics.setColor(255, 255, 255)

  -- draw dots
  for x = -2-math.ceil(grid.w/2), grid.w+2+math.ceil(grid.w/2) do
    for y = 1, grid.h do
      -- find coords of points
      local ox, oy = map.get_node_coords(x+x_pos, y)
      --determine type of destination
      local type = map.get_node_type(x+x_pos, y)
      -- color it if selected
      if target.x == x+x_pos and target.y == y then
        type = type + 7
      end

      -- draw
      love.graphics.draw(img.icons, quad.icons[type], math.floor(ox-scroll), math.floor(oy), 0, 1, 1, 8, 8)
    end
  end

  love.graphics.setCanvas(canvas.scroll)
  love.graphics.clear()

  love.graphics.draw(img.map, math.floor(scroll * .8 % 320), 0)
  love.graphics.draw(img.map, math.floor(scroll * .8 % 320 - 320), 0)
  love.graphics.draw(img.scrollfront, 0, 0)

  if map.node_is_option(target.x, target.y) then
    love.graphics.setCanvas(canvas.note)
    love.graphics.clear()

    -- draw note
    love.graphics.draw(img.note, 0, 0) -- draw background
    local reward = 0
    local type = map.get_node_type(target.x, target.y)
    if type > 1 then
      love.graphics.setColor(60, 178, 36)
      love.graphics.draw(img.noteicons, quad.noteicons[1], 2, 16)
      love.graphics.print(type_name[type], 16, 19)
      reward = 1
    end
    -- draw difficulty
    love.graphics.setColor(204, 40, 40)
    love.graphics.draw(img.noteicons, quad.noteicons[2], 2, 16 + reward * 14)
    love.graphics.print(map.get_node_difficulty_text(target.x, target.y), 16, 19 + reward * 14)

    -- draw distance
    love.graphics.setColor(64, 51, 102)
    love.graphics.draw(img.noteicons, quad.noteicons[3], 2, 16 + (reward+1) * 14)
    love.graphics.print(tostring(map.get_node_distance(target.x, target.y, path[#path].x, path[#path].y)).." mi.", 16, 19 + (reward+1) * 14)
    love.graphics.setColor(255, 255, 255)
  end

  love.graphics.setCanvas(canvas.window)
  love.graphics.clear()

  love.graphics.draw(canvas.map, 64+map_pos.x, map_pos.y)
  love.graphics.draw(img.scrollback, map_pos.x, map_pos.y)
  love.graphics.draw(canvas.scroll, map_pos.x, map_pos.y)
  love.graphics.draw(img.scrollback, grid.w*64+192+map_pos.x, map_pos.y, 0, -1, 1)
  love.graphics.draw(canvas.scroll, grid.w*64+128+map_pos.x, map_pos.y)
  -- draw note
  if map.node_is_option(target.x, target.y) then
    local x, y = map.get_node_coords(target.x, target.y)
    love.graphics.draw(canvas.note, math.floor(x+64+8+map_pos.x)-scroll, math.floor(y-8+map_pos.y))
  end

  love.graphics.setCanvas()
end

map.keypressed = function(key)
  if key == "right" then
    target.x = target.x + 1
  elseif key == "left" then
    target.x = target.x - 1
  elseif key == "down" then
    target.y = target.y + 1
  elseif key == "up" then
    target.y = target.y - 1

  elseif key == "x" then
    target.x = path[#path].x
    target.y = path[#path].y
  elseif key == "z" then
    if map.node_is_option(target.x, target.y) then
      -- switch to game
      state = "game"
      level.start(map.get_node_difficulty(target.x, target.y), map.get_node_distance(target.x, target.y, path[#path].x, path[#path].y), map.get_node_type(target.x, target.y))

      -- update map
      path[#path+1] = {x = target.x,y = target.y}
      map.find_options()
    end
  end
end

map.node_is_option = function(x, y)
  for i, v in ipairs(options) do
    if v.x == x and v.y == y then
      return true
    end
  end
  return false
end

map.get_node_coords = function(x, y)
  math.randomseed(map_seed+x*y)
  return x*grid.t+math.random(-grid.t, grid.t)*.33, y*grid.t+math.random(-grid.t, grid.t)*.33
end

map.get_node_type = function(x, y)
  math.randomseed(map_seed+x*y)
  if math.random(0, 3) == 0 then
    return math.random(2, 7)
  else
    return 1
  end
end

map.get_node_difficulty = function(x, y)
  math.randomseed(map_seed+x*y)
  local difficulty = x + math.random(-2, 2)
  if difficulty < 1 then
    difficulty = 1
  end
  return difficulty
end

map.get_node_difficulty_text = function(x, y)
  local dif = map.get_node_difficulty(target.x, target.y)
  local dif_txt = "Light"
  if dif > 4 then
    dif_txt = "Heavy"
  elseif dif > 2 then
    dif_txt = "Medium"
  end
  return dif_txt
end

map.get_node_distance  = function(x1, y1, x2, y2)
  x1, y1 = map.get_node_coords(x1, y1)
  x2, y2 = map.get_node_coords(x2, y2)
  return math.floor(math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)))
end

map.find_options = function()
  options = {}
  local x, y = path[#path].x, path[#path].y
  for oy = y-1, y+1 do
    for ox = x, x+1 do
      if ox ~= x or oy ~= y then -- make sure it isn't current point
        if oy >= 1 and oy <= grid.h and (#path < 2 or (path[#path-1].x ~= ox or path[#path-1].y ~= oy)) then
          options[#options+1] = {x = ox, y = oy}
        end
      end
    end
  end
end

map.dotted_line = function(x1, y1, x2, y2, gap)
  local gap = gap or 4

  local r = math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
  local theta = math.atan2((y2-y1), (x2-x1))

  for i = 0, math.floor(r / (gap*2)) do
    love.graphics.line(x1 + i*gap*2*math.cos(theta), y1 + i*gap*2*math.sin(theta), x1 + (i*gap*2+gap)*math.cos(theta), y1 + (i*gap*2+gap)*math.sin(theta))
  end
end

return map
