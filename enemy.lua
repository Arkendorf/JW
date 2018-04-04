local ai = require "enemy_ai"

local enemy = {}

enemy.load = function()
  enemies = {}
  enemy_info = {}
  enemy_info.crosser = {ai = {1, 1, 1}, atk_delay = 3, speed = 2, stop = 0.9, r = 16, hp = 1, score = 1, img = "fly"}
  enemy_info.bigboy = {ai = {1, 1, 1}, atk_delay = 2, speed = 1, stop = 0.9, r = 24, hp = 2, score = 2, img = "fly"}
end

enemy.update = function(dt)
  for i, v in pairs(enemies) do
    -- move the ai
    ai.move[enemy_info[v.type].ai[2]](i, v, dt)

    -- adjust position and velocity
    v.p = vector.sum(v.p, v.d)
    v.d = vector.scale(enemy_info[v.type].stop, v.d)

    -- delete enemy if it has no health
    if v.hp <= 0 then
      -- drop
      for j = 1, math.random(0, enemy_info[v.type].score) do
        local chance = math.random(1, 100)
        if chance <= 10 then
          drop.new(2, v.p, math.random(4, 8)) -- ammo
        elseif chance <= 20 then
          drop.new(1, v.p, 1) -- hp
        else
          drop.new(3, v.p, 1) -- money
        end
      end

      stats.kills = stats.kills + 1 -- increase 'kills' stat
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
    love.graphics.draw(shipimg[enemy_info[v.type].img], shipquad[enemy_info[v.type].img][v.frame], math.floor(v.p.x), math.floor(v.p.y), math.atan2(v.a.y, v.a.x), 1, 1, 16, 16)
  end
end

enemy.new = function(type) -- add enemy to open space in list
  local spot = opening(enemies)
  local info = enemy_info[type]
  enemies[spot] = {p = {x = 0, y = 0}, d = {x = 0, y = 0}, a = {x = 1, y = 0}, r = info.r, hp = info.hp, atk = 0, type = type, info = {}, frame = 1}
  -- do first-time setup for enemy
  ai.load[info.ai[1]](spot, enemies[spot])
end

return enemy
