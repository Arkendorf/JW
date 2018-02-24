vector = require "vector"
enemy = require "enemy"
bullet = require "bullet"
collision = require "collision"

love.load = function()
  screen = {w = love.graphics.getWidth(), h = love.graphics.getHeight()}

  char = {p = {x = 0, y = 0}, d = {x = 0, y = 0}, a = {x = 0, y = 0}, hp = 3, inv = 5, atk = 0, r = 16}
  char_info = {speed = 1, stop = 0.8, atk_delay = .1, inv_time = 1}

  bullet.load()

  enemy.load()

  scroll = {pos = 0, v = 0}
end

love.update = function(dt)
  -- do scrolling thing
  scroll.v = scroll.v + dt * 60 * 0.5
  scroll.pos = scroll.pos + scroll.v
  scroll.v = scroll.v * 0.9

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
    bullet.new("basic", char.p, char.a, 1)
    char.atk = char_info.atk_delay
  elseif char.atk > 0 then
    char.atk = char.atk - dt
  end

  -- lower invincibility
  if char.inv > 0 then
    char.inv = char.inv - dt
  end

  -- update bullet
  bullet.update(dt)

  -- update enemies
  enemy.update(dt)
end

love.draw = function()
  -- flash if invincibile
  if char.inv > 0 then
    love.graphics.setColor(255, 255, 255, 255*math.floor(math.sin(char.inv*16)+0.5))
  end

  -- draw char
  love.graphics.circle("line", char.p.x, char.p.y, char.r, 32)
  love.graphics.line(char.p.x, char.p.y, char.p.x+char.a.x*16, char.p.y+char.a.y*16)

  -- reset color
  love.graphics.setColor(255, 255, 255)

  -- draw bullets
  bullet.draw()

  -- draw enemies
  enemy.draw()

  love.graphics.print(scroll.pos)
end

opening = function(a) -- find available space in list 'a'
  for i, v in ipairs(a) do
    if v == nil then
      return i
    end
  end
  return #a + 1
end
