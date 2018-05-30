local tutorial = {}

local wait = 0
local step = 1

tutorial.start = function()
  tutorial.active = true
  level.start(0, 20, 2)
  wait = 2
end

tutorial.update = function(dt)
  if wait > 0 then
    wait = wait - dt
  elseif step == 1 then
    textbox.start({{text = "Hello there! I'll be giving you your basic training, so you can become a Flioneer of the Royal Air Force!", image = 2},
                   {text = "To move, use the arrow keys.", image = 2},
                   {text = "Got it.", image = 1}})
    step = 2
    wait = 4
  elseif step == 2 then
    enemy.new("crosser", 1)
    step = 3
    wait = 2
  elseif step == 3 then
    textbox.start({{text = "Uh oh, looks like we've encountered some resistance!", image = 2},
                   {text = "Press 'z' to fire you weapon.", image = 2},
                   {text = "Understood.", image = 1}})
    step = 4
  end
end

return tutorial
