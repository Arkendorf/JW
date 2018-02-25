local drop = {}

drop.load = function()
  drops = {}
end

drop.update = function(dt)
  for i, v in pairs(drops) do
    v.p = vector.sum(v.p, vector.scale(8 * dt * 60, v.d))
    v.d = vector.scale(0.8, v.d)

    -- increase variable if picked up
    if collision.overlap(char, v) and char[v.type] < char_info[v.type.."_max"] then
      if char[v.type]+v.num < char_info[v.type.."_max"] then -- if new quantity is under max, set quantity to new quantity
        char[v.type] = char[v.type] + v.num
      else -- if new quantity is over max, set it to max
        char[v.type] = char_info[v.type.."_max"]
      end
      drops[i] = nil -- remove drop
    end
  end
end

drop.draw = function()
  for i, v in pairs(drops) do
    love.graphics.circle("line", v.p.x, v.p.y, v.r, 8)
  end
end

drop.new = function(type, p, num)
  drops[opening(drops)] = {type = type, p = p, d = {x = math.random(-10, 10)/10, y = math.random(-10, 10)/10}, r = 4, num = num}
end

return drop
