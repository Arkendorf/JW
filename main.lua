vector = require "vector"

love.load = function()
  screen = {w = love.graphics.getWidth(), h = love.graphics.getHeight()}

  enemies = {}
  new_enemy("crosser", 0, 100)
end

love.update = function(dt)
  for i, v in ipairs(enemies) do
    if v.type == "crosser" then
      -- find direction if it's not set
      if v.info.dir == nil then
        if v.p.x < screen.w/2 then
          v.info.dir = 1
        else
          v.info.dir = -1
        end
      end

      -- set angle
      v.a.x = .7 * v.info.dir
      v.a.y = -.7

      -- move
      v.d.x = v.info.dir * dt * 60 * 4
    end

    -- do basics
    v.p = vector.sum(v.p, v.d)
    v.d = vector.scale(.9, v.d)
  end
end

love.draw = function()
  for i, v in ipairs(enemies) do
    love.graphics.circle("line", v.p.x, v.p.y, v.r, 32)
    love.graphics.line(v.p.x, v.p.y, v.p.x+v.a.x*v.r, v.p.y+v.a.y*v.r)
  end
end

opening = function(a) -- find available space in list 'a'
  for i, v in ipairs(a) do
    if v == nil then
      return i
    end
  end
  return #a + 1
end

new_enemy = function(type, x, y) -- add enemy to open space in list
  enemies[opening(enemies)] = {p = {x = x, y = y}, d = {x = 0, y = 0}, a = {x = 1, y = 0}, r = 16, type = type, info = {}}
end
