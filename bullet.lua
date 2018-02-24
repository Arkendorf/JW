local bullet = {}

bullet.load = function()
  bullets = {}
end

bullet.update = function(dt)
  for i, v in pairs(bullets) do
    v.p = vector.sum(v.p, vector.scale(6 * dt * 60, v.d))

    -- check if bullet is off screen
    if v.p.x < 0 or v.p.x > screen.w or v.p.y < 0 or v.p.y > screen.h then
      bullets[i] = nil
    end

    if v.side == 1 then -- check for collision with enemies
      for j, w in pairs(enemies) do
        if collision.overlap(v, w) then
          w.hp = w.hp - 1
          bullets[i] = nil
        end
      end
    else -- check for collision with player
      if collision.overlap(v, char) then
        if char.inv <= 0 then
          char.hp = char.hp - 1
        end
        bullets[i] = nil
        char.inv = char_info.inv_time
      end
    end
  end
end

bullet.draw = function()
  for i, v in pairs(bullets) do
    love.graphics.circle("line", v.p.x, v.p.y, v.r, 8)
  end
end

bullet.new = function(type, p, d, side)
  bullets[opening(bullets)] = {p = p, d = d, r = 4, side = side}
end

return bullet
