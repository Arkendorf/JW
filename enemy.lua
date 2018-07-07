local ai = require "enemy_ai"
local shader = require "shader"

local enemy = {}

enemy.load = function()
  enemies = {}
  enemy_info = {}

  -- enemies
  enemy_info.crosser = {ai = {"cross", "cross", "default", "straight"}, atk_delay = 3, speed = 1, stop = 0.9, r = 16, hp = 1, score = 1, img = "biplane", bullet = "basic"}
  enemy_info.fly = {ai = {"turn", "weave", "default", "straight"}, atk_delay = 2, speed = 1.5, turn_speed = 1, stop = 0.9, r = 16, hp = 1, score = 1, img = "fly", bullet = "basic"}
  enemy_info.double = {ai = {"cross", "patrol", "default", "double"}, atk_delay = 2, speed = 1, stop = 0.9, r = 24, hp = 3, score = 4, img = "double", bullet = "basic"}
  enemy_info.glider = {ai = {"turn", "follow", "default", "straight"}, atk_delay = 3, speed = 1, turn_speed = 1.5, stop = 0.9, r = 16, hp = 1, score = 3, img = "glider", bullet = "basic"}
  enemy_info.scout = {ai = {"turn", "follow", "passive", "straight"}, atk_delay = 3, speed = 2, turn_speed = 1, stop = 0.9, r = 12, hp = 1, score = 2, img = "scout", bullet = "basic"}
  enemy_info.galleon = {ai = {"cross", "bounce", "default", "side"}, atk_delay = 4, speed = .5, stop = 0.9, r = 20, hp = 4, score = 5, img = "galleon", bullet = "basic"}
  enemy_info.balloon = {ai = {"point", "point", "default", "aim"}, atk_delay = 5, speed = 1, stop = 0.9, r = 12, hp = 1, score = 3, img = "balloon", bullet = "basic"}
  enemy_info.bigplane = {ai = {"cross", "patrol", "default", "aim"}, atk_delay = 3, speed = 1, stop = 0.9, r = 24, hp = 3, score = 6, img = "bigplane", bullet = "basic", turrets = {{img = "turret", offset = 0}}}
  enemy_info.trapazoid = {ai = {"cross", "cross", "default", "aim"}, atk_delay = 3, speed = 1, stop = 0.9, r = 16, hp = 1, score = 4, img = "trapazoid", bullet = "basic", turrets = {{img = "turret", offset = 0}}}
  enemy_info.drone = {ai = {"point", "point", "default", "plus"}, atk_delay = 4, speed = 1, stop = 0.9, r = 12, hp = 1, score = 2, img = "drone", bullet = "basic"}
  enemy_info.wasp = {ai = {"turn", "weave", "default", "aim"}, atk_delay = 1, speed = 1, turn_speed = .5, stop = 0.9, r = 20, hp = 2, score = 4, img = "wasp", bullet = "basic", turrets = {{img = "gun", offset = 0}}}

  -- bosses
  enemy_info.gorious = {boss = true, ai = {"circle", "circle", "volley", "quad"}, atk_delay = .3, speed = 1, stop = 0.9, r = 24, hp = 5, score = 8, img = "gorious", bullet = "basic", icon = 3,
         text = {{text = "You're not gonna get out of here that easily!", image = 3},
                 {text = "If you insist.", image = 1}}}
  enemy_info.beetle = {boss = true, ai = {"turn", "follow", "default", "straight"}, atk_delay = .5, speed = 4, turn_speed = 3, stop = 0.9, r = 24, hp = 8, score = 4, img = "beetle", bullet = "mine", icon = 4,
         text = {{text = "Get outta my way!", image = 4},
                 {text = "Not happening.", image = 1},
                 {text = "I'll just have to run you over then!", image = 4}}}
  enemy_info.orca = {boss = true, ai = {"spawner", "spawner", "default", "aim"}, atk_delay = 3, speed = 1, turn_speed = 2, stop = 0.9, r = 24, hp = 8, score = 12, img = "orca", bullet = "missile", turrets = {{img = "cannon", offset = 8}}, icon = 5,
        text = {{text = "Turn back, while you still can", image = 5},
                {text = "I'm sorry, but I have a job to do.", image = 1},
                {text = "You're making a mistake...", image = 5}}}
  enemy_info.train_engine = {boss = true, ai = {"train", "follow", "default", "aim"}, atk_delay = 2, speed = 2, turn_speed = 2, stop = 0.9, r = 24, hp = 9, score = 16, img = "engine", bullet = "arrow", turrets = {{img = "gun", offset = 0}}, icon = 6,
       text = {{text = "You don't know who you're messing with...", image = 6}}}
  enemy_info.train_car = {nospawn = true, boss = true, ai = {"turn", "train", "default", "aim"}, atk_delay = 2, speed = 2, turn_speed = 2, stop = 0.9, r = 24, hp = 3, score = 2, img = "car", bullet = "arrow", turrets = {{img = "gun", offset = -8}}}



  ship_width = {}
  for i, v in pairs(shipimg) do
    ship_width[i] = v:getHeight()
  end

  shot_phrase = {"Got a shot in!", "Hit 'em!", "Direct hit!", "Landed a shot!", "Bullseye!", "Shot 'em!"}
  dmg_phrase = {"Under fire!", "I'm hit!", "Taking damage!", "I'm damaged!", "Taking shots!", "Under attack!"}
end

enemy.update = function(dt)
  for i, v in pairs(enemies) do
    -- move the ai
    ai.move[enemy_info[v.type].ai[2]](i, v, dt)

    -- adjust position and velocity
    v.p = vector.sum(v.p, v.d)
    v.d = vector.scale(enemy_info[v.type].stop, v.d)

    -- collide with edges (if boss)
    if enemy_info[v.type].boss then
      if v.p.x+v.r < 0 then
        v.p.x = -v.r
      end
      if v.p.x-v.r > screen.w then
        v.p.x = screen.w+v.r
      end
      if v.p.y+v.r < 0 then
        v.p.y = -v.r
      end
      if v.p.y-v.r > screen.h then
        v.p.y = screen.h+v.r
      end
    end

    if v.inv > 0 then-- lower invincibility
      v.inv = v.inv - dt
    end

    -- delete enemy if it has no health
    if v.hp <= 0 then
      -- drop
      for j = 1, math.random(0, enemy_info[v.type].score) do
        local chance = math.random(1, 10)
        if chance <= 2 then
          drop.new(2, v.p, math.random(4, 8)*v.tier/char_info.weapons[1].tier) -- ammo
        elseif chance <= 3 then
          drop.new(1, v.p, v.tier) -- hp
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

    if v.bubble then -- reduce bubble time
      v.bubble.t  = v.bubble.t - dt
      if v.bubble.t < 0 then
        v.bubble = false
      end
    end
  end
end

enemy.draw = function()
  for i, v in pairs(enemies) do
    -- draw enemy
    local img = enemy_info[v.type].img
    local ship_angle = math.atan2(v.a.y, v.a.x)
    local inv = false -- flash if invincible
    if v.inv > 0 and math.floor(math.sin(v.inv*8)+0.5) == 0 then
      love.graphics.setShader(shader.fill)
      inv = true
    end
    love.graphics.draw(shipimg[img], shipquad[img][math.floor(v.frame)], math.floor(v.p.x), math.floor(v.p.y), ship_angle, 1, 1, ship_width[img]/2, ship_width[img]/2)
    if not inv then
      love.graphics.setColor(tiers[v.tier].color)
    end
    love.graphics.draw(shipimg[img.."_overlay"], shipquad[img.."_overlay"][math.floor(v.frame)], math.floor(v.p.x), math.floor(v.p.y), ship_angle, 1, 1, ship_width[img]/2, ship_width[img]/2)
    if not inv then
      love.graphics.setColor(255, 255, 255)
    else
      love.graphics.setShader()
    end
    if enemy_info[v.type].turrets then -- draw turrets
      local char_angle = math.atan2(char.p.y-v.p.y, char.p.x-v.p.x)
      for j, w in ipairs(enemy_info[v.type].turrets) do
        local x_offset = w.offset*math.cos(ship_angle)
        local y_offset = w.offset*math.sin(ship_angle)
        love.graphics.draw(shipimg[w.img], math.floor(v.p.x+x_offset), math.floor(v.p.y+y_offset), char_angle, 1, 1, ship_width[w.img]/2, ship_width[w.img]/2)
      end
    end
    if v.bubble then -- draw text bubble
      enemy.draw_bubble(math.floor(v.p.x), math.floor(v.p.y), v.bubble.phrase)
    end
  end
end

enemy.new = function(type, tier) -- add enemy to open space in list
  local spot = opening(enemies)
  local info = enemy_info[type]
  enemies[spot] = {p = {x = 0, y = 0}, d = {x = 0, y = 0}, a = {x = 1, y = 0}, r = info.r, hp = info.hp*tier, atk = 0, type = type, info = {}, frame = 1, tier = tier, trail = 0, immune = {}, inv = 0}
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
    particle.new("spark", p, vector.scale(-12+math.random(-4, 4), d), vector.scale(-1, a)) -- character trail
  end
end

enemy.kill = function(i, v)
  enemies[i] = nil
  if enemy_info[v.type].boss and bossfight.active then
    local stop = true
    for j, w in pairs(enemies) do
      if j ~= i and enemy_info[w.type].boss then
        stop = false
        break
      end
    end
    if stop then
      bossfight.pause = 2
      bossfight.active = false
    end
  end
end

enemy.stop_dist = function(v)
  return vector.scale(1/(1-enemy_info[v.type].stop), v.d)
end

enemy.draw_bubble = function(x, y, text)
  love.graphics.draw(img.bubble, quad.bubble[1], x, y-16)
  local tile_num = math.ceil((font:getWidth(text)-24)/16)
  for i = 1, tile_num do
    love.graphics.draw(img.bubble, quad.bubble[2], x+i*16, y-16)
  end
  love.graphics.draw(img.bubble, quad.bubble[3], x+(tile_num+1)*16, y-16)
  love.graphics.setColor(palette.grey)
  love.graphics.print(text, x+4, y-12)
  love.graphics.setColor(255, 255, 255)
end

return enemy
