local hud = {}

hud.draw = function()
  love.graphics.draw(img.board, 4, 4)
  love.graphics.print(hud.num_to_str(char.hp), 23, 11)
  love.graphics.print(hud.num_to_str(char.ammo), 69, 11)
  love.graphics.print(hud.num_to_str(money), 115, 11)
  if state == "game" then
    love.graphics.print(hud.num_to_str(math.ceil(level.scroll.goal-level.scroll.pos)), 161, 11)
  else
    love.graphics.print("000", 161, 11)
  end
end

hud.num_to_str = function(num)
  local str = tostring(num)
  for i = 1, 3-string.len(str) do
    str = "0"..str
  end
  return str
end

return hud
