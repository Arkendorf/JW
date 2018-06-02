local ai = require "bullet_ai"

local bullet = {}

bullet.load = function()
  bullets = {}
  bullet_info = {}
  bullet_info.basic = {ai = {1, 1}, speed = 6, dmg = 1, r = 4, img = "bullet"}
  bullet_info.bomb = {ai = {2, 2}, speed = 4, dmg = 1, r = 6, img = "bomb", pierce = true}
  bullet_info.arrow = {ai = {1, 1}, speed = 8, dmg = 1, r = 2, img = "arrow", pierce = true}

  weapon_info = {}
  weapon_info[1] = {bullet = "basic", ammo = 1, delay = .2}
  weapon_info[2] = {bullet = "bomb", ammo = 4, delay = .4}
  weapon_info[3] = {bullet = "arrow", ammo = 1, delay = .3}
end

bullet.update = function(dt)
  for i, v in pairs(bullets) do
    -- update per bullet ai
    ai.update[bullet_info[v.type].ai[2]](i, v, dt)

    -- do damage
    if v.side == 1 then -- check for collision with enemies
      for j, w in pairs(enemies) do
        if collision.overlap(v, w) and not w.immune[i] then
          if math.random(0, 1) == 0 and not w.bubble then -- enemy
            w.bubble = {phrase = dmg_phrase[math.random(1, #dmg_phrase)], t = 2}
          end
          if math.random(0, 1) == 0 and not char.bubble then -- char
            char.bubble = {phrase = shot_phrase[math.random(1, #shot_phrase)], t = 2}
          end
          w.hp = w.hp - bullet_info[v.type].dmg*v.tier
          stats.hits = stats.hits + 1 -- increase 'hits' stat
          if not bullet_info[v.type].pierce then
            bullet.delete(i)
          else
            w.immune[i] = true
          end
        end
      end
    else -- check for collision with player
      if collision.overlap(v, char) and not char.immune[i] then
        if char.inv <= 0 then
         if math.random(0, 1) == 0 and not enemies[v.parent].bubble then -- enemy
            enemies[v.parent].bubble = {phrase = shot_phrase[math.random(1, #dmg_phrase)], t = 2}
         end
         if math.random(0, 1) == 0 and not char.bubble then -- char
           char.bubble = {phrase = dmg_phrase[math.random(1, #dmg_phrase)], t = 2}
         end
          char.hp = char.hp - bullet_info[v.type].dmg*v.tier
          char.inv = char_info.inv_time
          stats.dmg = stats.dmg + 1 -- increase 'dmg' stat
        end
        if not bullet_info[v.type].pierce then
          bullet.delete(i)
        else
          char.immune[i] = true
        end
      end
    end
    -- check if bullet is off screen
    if v.p.x < 0 or v.p.x > screen.w or v.p.y < 0 or v.p.y > screen.h then
      bullet.delete(i)
    end
  end
end

bullet.draw = function()
  for i, v in pairs(bullets) do
    love.graphics.draw(bulletimg[bullet_info[v.type].img], bulletquad[bullet_info[v.type].img][v.frame], math.floor(v.p.x), math.floor(v.p.y), v.angle, 1, 1, 16, 16)
    love.graphics.setColor(tiers[v.tier].color)
    love.graphics.draw(bulletimg[bullet_info[v.type].img.."_overlay"], bulletquad[bullet_info[v.type].img.."_overlay"][v.frame], math.floor(v.p.x), math.floor(v.p.y), v.angle, 1, 1, 16, 16)
    love.graphics.setColor(255, 255, 255)
  end
end

bullet.new = function(type, p, d, side, tier, parent)
  local spot = opening(bullets)
  local info = bullet_info[type]
  bullets[spot] = {type = type, p = p, d = d, r = info.r, side = side, angle = math.atan2(d.y, d.x), frame = 1, tier = tier, parent = parent, info = {}}
  -- perform first-time setup
  ai.load[info.ai[1]](spot, bullets[spot])
end

bullet.delete = function(i)
  bullets[i] = nil
  for i, v in ipairs(enemies) do
    if v.immune[i] then
      v.immune[i] = false
    end
  end
  if char.immune[i] then
    char.immune[i] = false
  end
end

return bullet
