local ai = require "particle_ai"

local particle = {}

particle.load = function()
  particles = {}
  particle_info = {}
  particle_info.trail = {img = "trail", ai = {1, 1}, speed = 24}
  particle_info.gas = {img = "gas", ai = {1, 1}, speed = 12}
  particle_info.smoke = {img = "smoke", ai = {1, 1}, speed = 12}
  particle_info.spark = {img = "spark", ai = {2, 1}, speed = 16}
  particle_info.pop = {img = "pop", ai = {1, 1}, speed = 16}
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
    love.graphics.draw(particleimg[info.img], particlequad[info.img][math.floor(v.frame)], v.p.x, v.p.y, v.angle, 1, 1, 16, 16)
    love.graphics.setColor(v.color)
    love.graphics.draw(particleimg[info.img.."_overlay"], particlequad[info.img.."_overlay"][math.floor(v.frame)], v.p.x, v.p.y, v.angle, 1, 1, 16, 16)
    love.graphics.setColor(255, 255, 255)
  end
end

particle.new = function(type, p, d, a, color)
  if not color then
    color = {255, 255, 255}
  end
  local spot = opening(particles)
  local info = particle_info[type]
  particles[spot] = {p = p, d = d, a = a, angle = 0, type = type, info = {}, frame = 1, color = color}
  -- perform first-time setup
  ai.load[info.ai[1]](spot, particles[spot])

end

return particle
