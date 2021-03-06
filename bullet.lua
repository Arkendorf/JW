local ai = require "bullet_ai"

local bullet = {}

bullet.load = function()
  bullets = {}
  bullet_info = {}
  bullet_info.basic = {ai = {"default", "default", "default"}, speed = 6, dmg = 1, r = 4, img = "bullet"}
  bullet_info.bomb = {ai = {"explosive", "bomb", "explode"}, speed = 4, t = 1, dmg = 1, r = 6, img = "bomb"}
  bullet_info.arrow = {ai = {"default", "default", "default"}, speed = 8, dmg = 1, r = 3, img = "arrow", pierce = true}
  bullet_info.mine = {ai = {"explosive", "bomb", "explode"}, speed = -2, t = 1, dmg = 1, r = 6, img = "mine"}
  bullet_info.missile = {ai = {"explosive", "missile", "explode"}, speed = 3, t = 1, dmg = 1, r = 6, img = "missile"}
  bullet_info.boomerang = {ai = {"boomerang", "boomerang", "default"}, speed = 5, dmg = 1, r = 5, img = "boomerang"}
  bullet_info.energy = {ai = {"vortex", "vortex", "default"}, speed = 3, dmg = 1, r = 3, img = "energy"}
  bullet_info.shotgun = {ai = {"shotgun", "default", "default"}, speed = 3, dmg = 1, r = 3, img = "pellet"}
  bullet_info.pellet = {ai = {"default", "default", "default"}, speed = 3, dmg = 1, r = 3, img = "pellet"}

  weapon_info = {}
  weapon_info[1] = {bullet = "basic", ammo = 1, delay = .2}
  weapon_info[2] = {bullet = "bomb", ammo = 2, delay = .4}
  weapon_info[3] = {bullet = "arrow", ammo = 1, delay = .4}
  weapon_info[4] = {bullet = "missile", ammo = 3, delay = .6}
  weapon_info[5] = {bullet = "boomerang", ammo = 1, delay = .3}
  weapon_info[6] = {bullet = "energy", ammo = 3, delay = .3}
  weapon_info[7] = {bullet = "shotgun", ammo = 3, delay = .5}
end

bullet.update = function(dt)
  for i, v in pairs(bullets) do
    -- update per bullet ai
    ai.update[bullet_info[v.type].ai[2]](i, v, dt)
    local d = vector.scale(dt*60, v.d)

    -- do damage
    if v.side == 1 then -- check for collision with enemies
      for j, w in pairs(enemies) do
        if collision.bullet(v, w, d) and not w.immune[i] then
          if w.inv <= 0 then
            if math.random(0, 1) == 0 and not w.bubble then -- enemy
              w.bubble = {phrase = dmg_phrase[math.random(1, #dmg_phrase)], t = 2}
            end
            if math.random(0, 1) == 0 and not char.bubble then -- char
              char.bubble = {phrase = shot_phrase[math.random(1, #shot_phrase)], t = 2}
            end
            w.hp = w.hp - bullet_info[v.type].dmg*v.tier
            stats.hits = stats.hits + 1 -- increase 'hits' stat
            if enemy_info[w.type].boss then
              w.inv = 1
            end
          end
          if not bullet_info[v.type].pierce and not v.active then -- activate bullet if not piercing
            v.active = true
            ai.activate[bullet_info[v.type].ai[3]](i, v, dt)
          elseif bullet_info[v.type].pierce then -- don't activate bullet when it hits
            w.immune[i] = true
          end
        end
      end
    else -- check for collision with player
      if collision.bullet(v, char, d) and not char.immune[i] then
        if char.inv <= 0 then
         if math.random(0, 1) == 0 and enemies[v.parent] and not enemies[v.parent].bubble then -- enemy
            enemies[v.parent].bubble = {phrase = shot_phrase[math.random(1, #dmg_phrase)], t = 2}
         end
         if math.random(0, 1) == 0 and not char.bubble then -- char
           char.bubble = {phrase = dmg_phrase[math.random(1, #dmg_phrase)], t = 2}
         end
          char.hp = char.hp - bullet_info[v.type].dmg*v.tier
          char.inv = char_info.inv_time
          stats.dmg = stats.dmg + 1 -- increase 'dmg' stat
        end
        if not bullet_info[v.type].pierce and not v.active then
          v.active = true
          ai.activate[bullet_info[v.type].ai[3]](i, v, dt)
        elseif bullet_info[v.type].pierce then
          char.immune[i] = true
        end
      end
    end

    -- update position
    v.p = vector.sum(v.p, d)

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
  bullets[spot] = {type = type, p = p, d = d, a = d, r = info.r, side = side, angle = math.atan2(d.y, d.x), frame = 1, tier = tier, parent = parent, info = {}}
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
