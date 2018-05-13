local hud = {}

local hud_pos = -184

hud.update = function(dt)
  if state ~= "pause" then
    hud_pos = graphics.zoom(state ~= "main", hud_pos, -184, 4, dt * 12)
  else
    hud_pos = graphics.zoom(oldstate ~= "main", hud_pos, -184, 4, dt * 12)
  end
end

hud.draw = function()
  love.graphics.draw(img.board, hud_pos, 4)
  if char.hp > 0 then
    love.graphics.print(hud.num_to_str(char.hp), hud_pos+19, 11)
  else
    love.graphics.print("000", hud_pos+19, 11)
  end
  love.graphics.print(hud.num_to_str(char.ammo), hud_pos+65, 11)
  love.graphics.print(hud.num_to_str(money), hud_pos+111, 11)
  if state == "game" or state == "pause" or state == "over" then
    love.graphics.print(hud.num_to_str(math.ceil(level.scroll.goal-level.scroll.pos)), hud_pos+157, 11)
  else
    love.graphics.print("000", hud_pos+157, 11)
  end
end

hud.num_to_str = function(num)
  if num > 999 then
    return "999"
  else
    local str = tostring(num)
    for i = 1, 3-string.len(str) do
      str = "0"..str
    end
    return str
  end
end

return hud
