local hud = {}

hud.draw = function()
  love.graphics.draw(img.board, 4, 4)
  love.graphics.print("Health: "..tostring(char.hp), 10, 10)
  love.graphics.print("Ammo: "..tostring(char.ammo), 90, 10)
  love.graphics.print("Money: "..tostring(money), 170, 10)
  love.graphics.print("Distance: ", 250, 10)
end

return hud
