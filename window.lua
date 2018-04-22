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
  -- love.window.setMode(w, h-12)

  canvas.game = love.graphics.newCanvas(screen.w, screen.h)
  canvas.window = love.graphics.newCanvas(w/screen.scale, h/screen.scale)
  canvas.clouds = love.graphics.newCanvas(screen.w, screen.h)

  b_offset = 0
end

window.update = function(dt)
  hud.update(dt)

  if #clouds < 6 and math.random(0, 60) == 0 then -- create new clouds
   if math.random(0, 1) == 0 then
      local dir = (math.random(0, 1)-.5)*2
      local y = math.random(0, screen.h)
      clouds[opening(clouds)] = {x = screen.w/2-(screen.w/2+96)*dir, y = y, oy = y, v = dir*math.random(0, 2), img = math.random(1, 4), start = level.scroll.pos}
    else
      clouds[opening(clouds)] = {x = math.random(0, screen.h), y = -48, oy = -screen.h-48, v = (math.random(0, 1)-.5)*math.random(0, 2), img = math.random(1, 4), start = level.scroll.pos}
    end
  end

  for i, v in pairs(clouds) do -- update clouds
    if freeze == false then
      v.x = v.x + dt * 12 * v.v
      v.y = (level.scroll.pos-v.start)*50 + v.oy
      if v.x < -128 or v.x > screen.w+128 or v.y > screen.h+48 then
        clouds[i] = nil
      end
    end
  end
end

window.draw = function()
  love.graphics.setCanvas(canvas.clouds) -- seperate canvas for game shadow purposes
  love.graphics.clear()

  -- draw drifting clouds
  for i, v in pairs(clouds) do
    love.graphics.draw(img.clouds, quad.clouds[v.img], math.floor(v.x), math.floor(v.y), 0, 1, 1, 128, 48)
  end

  love.graphics.setCanvas(canvas.window)
  love.graphics.clear()

  -- draw background
  for i = -math.ceil(screen.h/600/2), math.ceil(screen.h/600/2) do
    love.graphics.draw(img.background, screen.ox, math.floor((b_offset/4) % 600) + i*600)
  end

  -- draw cloud shadows
  love.graphics.setShader(shader.shadow)
  for i, v in pairs(clouds) do
    love.graphics.setColor(0, 127, 33)
    love.graphics.draw(img.clouds, quad.clouds[v.img], math.floor(v.x)+screen.ox, (level.scroll.pos-v.start)*25, 0, .2, .2, 128, 48)
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()

  love.graphics.draw(canvas.clouds, screen.ox, screen.oy)

  -- draw shadows
  if state == "game" or oldstate == "game" then
    shader.cloud_shadow:send("clouds", canvas.clouds)
    love.graphics.setShader(shader.cloud_shadow)
    love.graphics.setColor(152, 219, 255)
    love.graphics.draw(canvas.game, screen.ox, screen.oy)
    love.graphics.setShader()
    love.graphics.setColor(255, 255, 255)
  end

  -- draw game
  love.graphics.draw(canvas.game, screen.ox, screen.oy)

  -- draw borders
  for i = -math.ceil(screen.h/400/2), math.ceil(screen.h/400/2) do
    love.graphics.draw(img.border, math.floor(screen.ox-600), math.floor(b_offset % 400) + i*400)
    love.graphics.draw(img.border, math.floor(screen.ox+screen.w+600), math.floor((b_offset-200) % 400) + i*400, 0, -1, 1)
  end

  hud.draw()

  love.graphics.setCanvas()

  love.graphics.draw(canvas.window, 0, 0, 0, screen.scale, screen.scale)
end

return window
