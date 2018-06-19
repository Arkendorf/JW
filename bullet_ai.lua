local ai = {}

ai.load = {}

ai.load.default = function(i, v) -- "basic"
end

ai.load.explosive = function(i, v) -- "bomb"
  v.info.t = 0
  v.info.pt = 0
end

ai.load.boomerang = function(i, v) -- "boomerang"
  v.info.v = bullet_info[v.type].speed
end

ai.load.vortex = function(i, v) -- "boomerang"
  v.info.pt = 0
end

ai.update = {}

ai.update.default = function(i, v, dt) -- "basic"
  particle.new("trail", v.p, {x = 0, y = 0}, v.d, tiers[v.tier].color) -- bullet trail
  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60, v.d))
end

ai.update.bomb = function(i, v, dt) -- "bomb"
  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60 * (1 - v.info.t/bullet_info[v.type].t), v.d))
  v.info.t = v.info.t + dt
  if v.info.t > bullet_info[v.type].t+0.4 then
    bullet.delete(i)
  elseif v.info.t > bullet_info[v.type].t then
    v.frame = 2
    v.r = 32
    particle.new("explosion", {x = v.p.x+math.random(-1600, 1600)/100, y = v.p.y+math.random(-1600, 1600)/100}, {x = 0, y = 0}, {x = math.random(-1, 1), y = math.random(-1, 1)})
  end
end

ai.update.missile = function(i, v, dt) -- "missile"
  v.info.t = v.info.t + dt
  if v.info.t > bullet_info[v.type].t+0.4 then
    bullet.delete(i)
  elseif v.info.t > bullet_info[v.type].t then
    v.frame = 2
    v.r = 24
    particle.new("explosion", {x = v.p.x+math.random(-1600, 1600)/100, y = v.p.y+math.random(-1600, 1600)/100}, {x = 0, y = 0}, {x = math.random(-1, 1), y = math.random(-1, 1)})
  else
    if v.info.pt <= 0 then
      particle.new("smoke", v.p, {x = 0, y = 0}, {x = math.random(-1, 1), y = math.random(-1, 1)})
      v.info.pt = math.random(0, 20)/100
    else
      v.info.pt = v.info.pt - dt
    end
    v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60, v.d))
  end
end

ai.update.boomerang = function(i, v, dt) -- "boomerang"
  particle.new("trail", v.p, {x = 0, y = 0}, v.d, tiers[v.tier].color) -- bullet trail
  v.p = vector.sum(v.p, vector.scale(v.info.v* dt * 60, v.d))
  if v.info.v > - bullet_info[v.type].speed then
    v.info.v = v.info.v - 0.08
  end
  v.angle = v.angle + math.rad(dt * 60) * 12
end

ai.update.vortex = function(i, v, dt) -- "boomerang"
  particle.new("trail", v.p, {x = 0, y = 0}, v.d, tiers[v.tier].color) -- bullet trail

  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60, v.d))
  if v.side == 1 then
    for j, w in pairs(enemies) do
      local angle = math.atan2(v.p.y-w.p.y, v.p.x-w.p.x)
      local mag = 516/(math.sqrt((w.p.x-v.p.x)*(w.p.x-v.p.x)+(w.p.y-v.p.y)*(w.p.y-v.p.y))*w.r)
      w.p = vector.sum(w.p, {x = mag*math.cos(angle), y = mag*math.sin(angle)})
    end
  else
    local angle = math.atan2(v.p.y-char.p.y, v.p.x-char.p.x)
    local mag = 516/(math.sqrt((char.p.x-v.p.x)*(char.p.x-v.p.x)+(char.p.y-v.p.y)*(char.p.y-v.p.y))*w.r)
    char.p = vector.sum(char.p, {x = mag*math.cos(angle), y = mag*math.sin(angle)})
  end

  if v.info.pt <= 0 then
    local angle = math.random(0, math.pi*200)/100
    local dir = {x = math.cos(angle), y = math.sin(angle)}
    particle.new("energy", vector.sum(v.p, vector.scale(16, dir)), vector.scale(bullet_info[v.type].speed, v.d), dir, tiers[v.tier].color) -- effect
    v.info.pt = math.random(1, 30)/100
  else
    v.info.pt = v.info.pt - dt
  end
end

ai.activate = {}

ai.activate.default = function(i, v, dt)
  bullet.delete(i)
end

ai.activate.explode = function(i, v, dt)
  v.info.t = bullet_info[v.type].t
end

return ai
