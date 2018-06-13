local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "basic"
end

ai.load[2] = function(i, v) -- "bomb"
  v.info.t = 0
  v.info.pt = 0
end

ai.update = {}

ai.update[1] = function(i, v, dt) -- "basic"
  particle.new("trail", v.p, {x = 0, y = 0}, v.d, tiers[v.tier].color) -- bullet trail
  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60, v.d))
end

ai.update[2] = function(i, v, dt) -- "bomb"
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

ai.update[3] = function(i, v, dt) -- "missile"
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

ai.activate = {}

ai.activate[1] = function(i, v, dt)
  bullet.delete(i)
end

ai.activate[2] = function(i, v, dt)
  v.info.t = bullet_info[v.type].t
end

return ai
