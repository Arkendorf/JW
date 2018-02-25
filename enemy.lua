local ai = require "ai"

local enemy = {}

enemy.load = function()
  enemies = {}
  enemy_info = {}
  enemy_info.crosser = {ai = {1, 1, 1}, atk_delay = 3}
  enemy.new("crosser", 0, 100)
end

enemy.update = function(dt)
  for i, v in pairs(enemies) do
    -- move the ai
    ai.move[enemy_info[v.type].ai[2]](i, v, dt)

    -- adjust position and velocity
    v.p = vector.sum(v.p, v.d)
    v.d = vector.scale(.9, v.d)

    -- delete enemy if it has no health
    if v.hp <= 0 then
      -- drop
      for j = 1, math.random(1, 4) do
        local chance = math.random(1, 100)
        if chance > 30 then
          drop.new("ammo", v.p, math.random(4, 16))
        else
          drop.new("hp", v.p, math.random(4, 16))
        end
      end

      enemies[i] = nil
    end

    if v.atk <= 0 then
      -- fire bullet
      ai.attack[enemy_info[v.type].ai[3]](i, v, dt)
      v.atk = enemy_info[v.type].atk_delay
    else
      -- decrease wait till next bullet
      v.atk = v.atk - dt
    end
  end
end

enemy.draw = function()
  for i, v in pairs(enemies) do
    love.graphics.circle("line", v.p.x, v.p.y, v.r, 32)
    love.graphics.line(v.p.x, v.p.y, v.p.x+v.a.x*v.r, v.p.y+v.a.y*v.r)
  end
end

enemy.new = function(type, x, y) -- add enemy to open space in list
  local spot = opening(enemies)
  enemies[spot] = {p = {x = x, y = y}, d = {x = 0, y = 0}, a = {x = 1, y = 0}, r = 16, hp = 4, atk = 0, type = type, info = {}}
  -- do first-time setup for enemy
  ai.load[enemy_info[type].ai[1]](spot, enemies[spot])
end

return enemy
