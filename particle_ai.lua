local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "basic"
  v.angle = math.atan2(v.a.y, v.a.x)
end

ai.load[2] = function(i, v) -- "basic"
  v.angle = math.atan2(v.a.y, v.a.x)+math.random(-math.pi*33, math.pi*33)/100
  local mag = math.sqrt(vector.mag_sq(v.d))
  v.d.x = mag * math.cos(v.angle)
  v.d.y = mag * math.sin(v.angle)
end

ai.load[3] = function(i, v) -- "explosion"
  v.angle = math.atan2(v.a.y, v.a.x)
  v.info.t = math.random(0, 20)/100
end

ai.update = {}

ai.update[1] = function(i, v, dt) -- "basic"
  v.p = vector.sum(v.p, vector.scale(dt * 12, v.d))

  v.frame = v.frame + dt * particle_info[v.type].speed
  if v.frame >= #particlequad[particle_info[v.type].img]+1 then
    particles[i] = nil
  end
end

ai.update[2] = function(i, v, dt) -- "explosion"
  if v.info.t <= 0 then
    v.frame = v.frame + dt * particle_info[v.type].speed
    if v.frame >= #particlequad[particle_info[v.type].img]+1 then
      particles[i] = nil
    end
  else
    v.info.t = v.info.t - dt
    if v.info.t <= 0 then
      v.frame = 1
    else
      v.frame = #particlequad[particle_info[v.type].img]
    end
  end
end

return ai
