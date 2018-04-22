local ai = require "particle_ai"

local particle = {}

particle.load = function()
  particles = {}
  particle_info = {}
  particle_info.smoke = {img = "smoke", ai = {1, 1}}
end

particle.update = function(dt)
  for i, v in pairs(particles) do
    -- update per bullet ai
    ai.update[particle_info[v.type].ai[2]](i, v, dt)
  end
end

particle.draw = function()
  for i, v in pairs(particles) do
    local info = particle_info[v.type]
    love.graphics.setColor(v.color)
    love.graphics.draw(particleimg[info.img], particlequad[info.img][math.floor(v.frame)], v.p.x, v.p.y, v.angle)
  end
  love.graphics.setColor(255, 255, 255)
end

particle.new = function(type, p, d, color)
  if not color then
    color = {255, 255, 255}
  end
  local spot = opening(particles)
  local info = particle_info[type]
  particles[spot] = {p = p, d = d, a = d, angle = 0, type = type, info = {}, frame = 1, color = color}
  -- perform first-time setup
  ai.load[info.ai[1]](spot, particles[spot])

end

return particle
