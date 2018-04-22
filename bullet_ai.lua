local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "basic"
end

ai.load[2] = function(i, v) -- "gas"
  v.angle = 0
end

ai.update = {}

ai.update[1] = function(i, v, dt) -- "basic"
  particle.new("trail", v.p, {x = 0, y = 0}, v.d, tiers[v.tier].color) -- bullet trail
  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60, v.d))
end

ai.update[2] = function(i, v, dt) -- "gas"
  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60, v.d))
  v.r = v.r + dt * 16
  v.frame = math.floor(v.r/4)
  if v.r > 20 then -- delete after radius reaches point
    bullets[i] = nil
  end
end

return ai
