vector = require "vector"

function love.load()
  char = {p = {x = 0, y = 0}, d = {x = 0, y = 0}, a = {x = 0, y = 0}, atk = 0, r = 16}
  char_info = {speed = 1, stop = 0.8, atk_delay = .1}

  proj = {}
end

function love.update(dt)
  -- movement
  if love.keyboard.isDown("right") then
    char.d.x = char.d.x + dt * 60 * char_info.speed
  end
  if love.keyboard.isDown("left") then
    char.d.x = char.d.x - dt * 60 * char_info.speed
  end
  if love.keyboard.isDown("down") then
    char.d.y = char.d.y + dt * 60 * char_info.speed
  end
  if love.keyboard.isDown("up") then
    char.d.y = char.d.y - dt * 60 * char_info.speed
  end

  -- adjust char pos
  char.p = vector.sum(char.p, char.d)


  -- adjust char angle
  char.a.x = char.d.x * (1 - char_info.stop)
  char.a.y = - 1
  char.a = vector.norm(char.a)

  -- adjust char velocity
  char.d = vector.scale(char_info.stop, char.d)

  -- attack
  if love.keyboard.isDown("z") and char.atk <= 0 then
    proj[#proj+1] = {p = char.p, d = char.a, r = 4, side = 1}
    char.atk = char_info.atk_delay
  elseif char.atk > 0 then
    char.atk = char.atk - dt
  end

  -- update projectiles
  for i, v in ipairs(proj) do
    v.p = vector.sum(v.p, vector.scale(6, v.d))
  end
end

function love.draw()
  love.graphics.circle("line", char.p.x, char.p.y, char.r, 32)
  love.graphics.line(char.p.x, char.p.y, char.p.x+char.a.x*16, char.p.y+char.a.y*16)

  for i, v in ipairs(proj) do
    love.graphics.circle("line", v.p.x, v.p.y, v.r, 8)
  end
end
