local ai = require "enemy_ai"

local enemy = {}

enemy.load = function()
  enemies = {}
  enemy_info = {}
  enemy_info.crosser = {ai = {1, 1, 1, 1}, atk_delay = 3, speed = 1, stop = 0.9, r = 16, hp = 1, score = 2, img = "biplane"}
  enemy_info.fly = {ai = {2, 2, 1, 1}, atk_delay = 2, speed = 1.5, turn_speed = 1, stop = 0.9, r = 16, hp = 1, score = 2, img = "fly"}
  enemy_info.bigcrosser = {ai = {3, 3, 1, 3}, atk_delay = 2, speed = 1, stop = 0.9, r = 24, hp = 3, score = 4, img = "bigplane"}
  enemy_info.glider = {ai = {2, 4, 1, 1}, atk_delay = 3, speed = 1, turn_speed = 1.5, stop = 0.9, r = 16, hp = 1, score = 3, img = "glider"}
  enemy_info.scout = {ai = {2, 4, 2, 1}, atk_delay = 3, speed = 2, turn_speed = 1, stop = 0.9, r = 12, hp = 1, score = 1, img = "scout"}
  enemy_info.galleon = {ai = {1, 5, 1, 4}, atk_delay = 4, speed = .5, stop = 0.9, r = 24, hp = 4, score = 5, img = "galleon"}
  enemy_info.boss_crosser = {boss = true, ai = {1, 1, 1, 1}, atk_delay = 3, speed = 1, stop = 0.9, r = 16, hp = 16, score = 2, img = "biplane", name = "El Gorious"}


  ship_width = {}
  for i, v in pairs(shipimg) do
    ship_width[i] = v:getHeight()
  end
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

      enemy.explosion(v)

      stats.kills = stats.kills + 1 -- increase 'kills' stat
      enemy.kill(i, v)
    end

    -- delete enemy if off screen
    if v.p.x+v.r < 0 or v.p.x-v.r > screen.w or v.p.y+v.r < 0 or v.p.y-v.r > screen.h then
      enemy.kill(i, v)
    end

    ai.attack[enemy_info[v.type].ai[3]](i, v, dt) -- call attack AI

    -- update animation
    v.frame = v.frame + dt * 12
    if v.frame >= #shipquad[enemy_info[v.type].img]+1 then
      v.frame = 1
    end

    -- update trail
    if v.trail <= 0 then
      enemy.dmg_particle(v.p, {x = 0, y = 0}, v.d, v.hp, enemy_info[v.type].hp*v.tier)
      v.trail = .5/enemy_info[v.type].speed
    else
      v.trail = v.trail - dt
    end
  end
end

enemy.draw = function()
  for i, v in pairs(enemies) do
    local img = enemy_info[v.type].img
    love.graphics.draw(shipimg[img], shipquad[img][math.floor(v.frame)], math.floor(v.p.x), math.floor(v.p.y), math.atan2(v.a.y, v.a.x), 1, 1, ship_width[img]/2, ship_width[img]/2)
    love.graphics.setColor(tiers[v.tier].color)
    love.graphics.draw(shipimg[img.."_overlay"], shipquad[img.."_overlay"][math.floor(v.frame)], math.floor(v.p.x), math.floor(v.p.y), math.atan2(v.a.y, v.a.x), 1, 1, ship_width[img]/2, ship_width[img]/2)
    love.graphics.setColor(255, 255, 255)
  end
end

enemy.new = function(type, tier) -- add enemy to open space in list
  local spot = opening(enemies)
  local info = enemy_info[type]
  enemies[spot] = {p = {x = 0, y = 0}, d = {x = 0, y = 0}, a = {x = 1, y = 0}, r = info.r, hp = info.hp*tier, atk = 0, type = type, info = {}, frame = 1, tier = tier, trail = 0}
  -- do first-time setup for enemy
  ai.load[info.ai[1]](spot, enemies[spot])
  return enemies[spot]
end

enemy.explosion = function(v)
  local num = math.ceil(ship_width[enemy_info[v.type].img]/16)/2
  for h = 1-num, num do
    for w = 1-num, num do
      particle.new("explosion", {x = v.p.x+w*16+math.random(-800, 800)/100, y = v.p.y+h*16+math.random(-800, 800)/100}, {x = 0, y = 0}, {x = math.random(-1, 1), y = math.random(-1, 1)})
    end
  end
end

enemy.dmg_particle = function(p, d, a, hp, max)
  particle.new("gas", p, vector.scale(-8+math.random(-4, 4), d), {x = math.random(-1, 1), y = math.random(-1, 1)}) -- character trail
  if hp < max then
    particle.new("smoke", p, vector.scale(-6+math.random(-4, 4), d), {x = math.random(-1, 1), y = math.random(-1, 1)}, {100, 100, 100}) -- character trail
  end
  if hp < max/2 then
    particle.new("spark", p, vector.scale(-12+math.random(-4, 4), a), vector.scale(-1, a)) -- character trail
  end
end

enemy.kill = function(i, v)
  enemies[i] = nil
  if enemy_info[v.type].boss and bossfight.active then
    bossfight.pause = 2
    bossfight.active = false
  end
end

return enemy
