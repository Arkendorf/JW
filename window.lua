local window = {}

local hud = require "hud"
local shader = require "shader"

local clouds = {}

window.load = function()
  -- set up window
  screen = {w = 600, h = 400}
  local w, h = love.window.getDesktopDimensions()
  if screen.w/screen.h < w/h then
    screen.scale = h/screen.h
  else
    screen.scale = w/screen.w
  end
  screen.ox = math.floor((w/screen.scale - screen.w) / 2)
  screen.oy = math.floor((h/screen.scale - screen.h) / 2)
  love.window.setFullscreen(true)

  canvas.game = love.graphics.newCanvas(screen.w, screen.h)
  canvas.menu = love.graphics.newCanvas(screen.w, screen.h)
  canvas.window = love.graphics.newCanvas(w/screen.scale, h/screen.scale)
  canvas.clouds = love.graphics.newCanvas(screen.w, screen.h)
  canvas.background = love.graphics.newCanvas(screen.w, screen.h)

  b_offset = 0

  shader.shadow:send("offset", {screen.ox, screen.oy})
  shader.shadow:send("screen", {screen.w, screen.h})
end

window.update = function(dt)
  hud.update(dt)

  if #clouds < 6 and math.random(0, 60) == 0 then -- create new clouds
   if level.scroll.v > 0 and math.random(0, 1) == 0 then
     clouds[opening(clouds)] = {x = math.random(0, screen.h), y = 0, oy = -screen.h-48, v = (math.random(0, 1)-.5)*math.random(0, 2), img = math.random(1, 4), start = b_offset}
    else
      local dir = (math.random(0, 1)-.5)*2
      clouds[opening(clouds)] = {x = screen.w/2-(screen.w/2+96)*dir, y = 0, oy = math.random(0, screen.h), v = dir*math.random(0, 2), img = math.random(1, 4), start = b_offset}
    end
  end

  for i, v in pairs(clouds) do -- update clouds
    if freeze == false then
      v.x = v.x + dt * 12 * v.v
      v.y = (b_offset-v.start)*50 + v.oy
      if v.x < -128 or v.x > screen.w+128 or v.y > screen.h+48 then
        clouds[i] = nil
      end
    end
  end
end

window.draw = function()
  love.graphics.setCanvas(canvas.background)
  love.graphics.clear()

  -- draw background
  for i = -math.ceil(screen.h/600/2), math.ceil(screen.h/600/2) do
    love.graphics.draw(img.background, 0, math.floor((b_offset*25) % 600) + i*600)
  end

  love.graphics.setCanvas(canvas.clouds) -- seperate canvas for game shadow purposes
  love.graphics.clear()

  -- draw drifting clouds
  for i, v in pairs(clouds) do
    love.graphics.draw(img.clouds, quad.clouds[v.img], math.floor(v.x), math.floor(v.y), 0, 1, 1, 128, 48)
  end

  if state ~= "game" and oldstate ~= "game" then -- basic background if not game
    love.graphics.setCanvas(canvas.game)
    love.graphics.clear()
    level.draw_background()
  end

  love.graphics.setCanvas(canvas.menu)
  hud.draw()

  love.graphics.setCanvas(canvas.window)
  love.graphics.clear()

  love.graphics.draw(canvas.background, screen.ox, screen.oy)

  -- draw cloud shadows
  shader.shadow:send("background", canvas.background)
  love.graphics.setShader(shader.shadow)
  for i, v in pairs(clouds) do
    love.graphics.draw(img.clouds, quad.clouds[v.img], math.floor(v.x)+screen.ox, math.floor((v.y+screen.h)/2)+screen.oy, 0, .2, .2, 128, 48)
  end

  -- draw clouds
  shader.cloud_shadow:send("game", canvas.game)
  love.graphics.setShader(shader.cloud_shadow)
  love.graphics.setColor(152, 219, 255)
  love.graphics.draw(canvas.clouds, screen.ox, screen.oy)
  love.graphics.setShader()
  love.graphics.setColor(255, 255, 255)

  -- draw game
  love.graphics.draw(canvas.game, screen.ox, screen.oy)

  -- draw menus
  love.graphics.draw(canvas.menu, screen.ox, screen.oy)


  -- draw verticle borders
  for i = -math.ceil(screen.h/400/2), math.ceil(screen.h/400/2) do
    love.graphics.draw(img.border, math.floor(screen.ox-600), math.floor(b_offset*100 % 400) + i*400)
    love.graphics.draw(img.border, math.floor(screen.ox+screen.w+600), math.floor((b_offset-2)*100 % 400) + i*400, 0, -1, 1)
  end

  -- draw horizontal borders
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, screen.w, screen.oy)
  love.graphics.rectangle("fill", 0, screen.h+screen.oy, screen.w, screen.oy)
  love.graphics.setColor(255, 255, 255)

  -- draw id
  love.graphics.print("Flioneer Pre-Alpha Release", 34+screen.ox, screen.h-font:getHeight()-2+screen.oy)

  love.graphics.setCanvas()

  love.graphics.draw(canvas.window, 0, 0, 0, screen.scale, screen.scale)
end

return window
