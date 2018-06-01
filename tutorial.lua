local tutorial = {}

local wait = 0
local step = 1
local type = 1
local type_text = {"Sometimes, you'll get nothing. This is indicated by a circle on the map. Press 'x' to continue.",
                   "Sometimes, you'll get a new weapon. Press 'z' to take it, then use the arrow keys and 'z' to put it in a slot. Press 'x' to continue.",
                   "Sometimes, you'll get an upgrade. Press 'z' to collect it, and 'x' to continue.",
                   "Sometimes, you'll get a health bonus. Press 'z' to take it, and 'x' to continue.",
                   "Sometimes, you'll get extra ammo. Press 'z' to take it, and 'x' to continue.",
                   "Sometimes, you'll receive money. Press 'z' to take it, and 'x' to continue.",
                   "Sometimes, you'll encounter a shop. Use the arrow keys to select an item, and press 'z' to purchase it. Press 'x' to continue."}

tutorial.start = function()
  tutorial.active = true
  type = math.random(1, 7)
  level.start(0, 16, type)
  wait = 3
  step = 1
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
    wait = 1
  elseif step == 3 then
    textbox.start({{text = "Uh oh, looks like we've encountered some resistance!", image = 2},
                   {text = "Press 'z' to fire you weapon.", image = 2},
                   {text = "Understood.", image = 1}})
    step = 4
  elseif step == 4 and #enemies < 1 then
    textbox.start({{text = "Nice job! Now all you have to do is get to the airship!", image = 2}})
    step = 5
  elseif step == 5 and state == "reward" then
    step = 6
    wait = 1
  elseif step == 6 then
    textbox.start({{text = "Once you're on the airship, you'll receive a monetary bonus depending on how well you did.", image = 2},
                   {text = "You'll also receive a random reward.", image = 2},
                   {text = type_text[type], image = 2}})
    step = 7
  elseif step == 7 and state == "map" then
    map.start() -- set up map
    step = 8
    wait = 1
  elseif step == 8 then
    textbox.start({{text = "Here, you can choose your next destination. Pay attention to the difficulty, reward, and length of the trip.", image = 2},
                   {text = "Use the arrow keys to choose a destination, then press 'z' to start. 'x' returns you to your current location.", image = 2},
                   {text = "Got all that?", image = 2},
                   {text = "Yes, sir!", image = 1},
                   {text = "I must leave you now. Good luck!", image = 2}})
    step = 9
  elseif step == 9 then
    tutorial.active = false
  end
end

return tutorial
