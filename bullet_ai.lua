local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "basic"
end

ai.load[2] = function(i, v) -- "bomb"
  v.info.t = 1
end

ai.update = {}

ai.update[1] = function(i, v, dt) -- "basic"
  particle.new("trail", v.p, {x = 0, y = 0}, v.d, tiers[v.tier].color) -- bullet trail
  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60, v.d))
end

ai.update[2] = function(i, v, dt) -- "bomb"
  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60 / v.info.t, v.d))
  v.info.t = v.info.t + dt * 3
  if v.info.t > bullet_info[v.type].speed+0.4 then
    bullet.delete(i)
  elseif v.info.t > bullet_info[v.type].speed then
    v.frame = 2
    v.r = 16
    particle.new("explosion", {x = v.p.x+math.random(-1600, 1600)/100, y = v.p.y+math.random(-1600, 1600)/100}, {x = 0, y = 0}, {x = math.random(-1, 1), y = math.random(-1, 1)})
  end
end

return ai
