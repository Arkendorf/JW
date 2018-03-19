local hud = {}

hud.draw = function()
  if state == "game" then
    level.draw()
  end
end

return hud
