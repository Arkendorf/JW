local graphics = {}

graphics.load = function()
  love.mouse.setVisible(false)

  love.graphics.setDefaultFilter("nearest", "nearest")

  font = love.graphics.newImageFont("font.png",
  " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
  "abcdefghijklmnopqrstuvwxyz" ..
  "0123456789!?.,':$[]%", 1)
  love.graphics.setFont(font)

  love.graphics.setLineStyle("rough")
  love.graphics.setLineWidth(2)

  -- images
  img = {}
  files = love.filesystem.getDirectoryItems("imgs")
  for i, v in ipairs(files) do
    img[string.sub(v, 1, -5)] = love.graphics.newImage("imgs/"..v)
  end

  -- quads
  quad = {}
  quad.mapdetail = graphics.spritesheet(img.mapdetail, 64, 64)
  quad.icons = graphics.spritesheet(img.icons, 16, 16)
  quad.noteicons = graphics.spritesheet(img.noteicons, 12, 12)
  quad.cardicons = graphics.spritesheet(img.cardicons, 16, 16)
  quad.cardimgs = graphics.spritesheet(img.cardimgs, 48, 48)
  quad.weaponimgs = graphics.spritesheet(img.weaponimgs, 48, 48)
  quad.drops = graphics.spritesheet(img.drops, 32, 32)
  quad.mainicons = graphics.spritesheet(img.mainicons, 32, 32)
  quad.propellor = graphics.spritesheet(img.propellor, 34, 34)
  quad.clouds = graphics.spritesheet(img.clouds, 256, 96)
  quad.bubble = graphics.spritesheet(img.bubble, 16, 16)
  quad.charicons = graphics.spritesheet(img.charicons, 64, 64)

  -- bullet images
  bulletimg, bulletquad = graphics.load_folder("bulletimgs")

  -- ship images
  shipimg, shipquad = graphics.load_folder("shipimgs")

  -- particle
  particleimg, particlequad = graphics.load_folder("particleimgs")

  -- canvases
  canvas = {}

  love.graphics.setBackgroundColor(255, 255, 255)
end

graphics.load_folder = function(str)
  local img = {}
  local quad = {}
  local files = love.filesystem.getDirectoryItems(str)
  for i, v in ipairs(files) do
    local name = string.sub(v, 1, -5)
    img[name] = love.graphics.newImage(str.."/"..v)
    local tile_size = img[name]:getHeight()
    quad[name] = graphics.spritesheet(img[name], tile_size, tile_size)
  end
  return img, quad
end


graphics.spritesheet = function(img, tw, th)
  local quads = {}
  for y = 0, math.ceil(img:getHeight()/th)-1 do
    for x = 0, math.ceil(img:getWidth()/tw)-1 do
      quads[#quads+1] = love.graphics.newQuad(x*tw, y * th, tw, th, img:getDimensions())
    end
  end
  return quads
end

graphics.dotted_line = function(x1, y1, x2, y2, gap)
  local gap = gap or 4

  local r = math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
  local theta = math.atan2((y2-y1), (x2-x1))

  for i = 0, math.floor(r / (gap*2)) do
    love.graphics.line(x1 + i*gap*2*math.cos(theta), y1 + i*gap*2*math.sin(theta), x1 + (i*gap*2+gap)*math.cos(theta), y1 + (i*gap*2+gap)*math.sin(theta))
  end
end

graphics.zoom = function(bool, num, min, max, scalar)
  if max-num <= 1 then
    num = max
  elseif num-min <= 1 then
    num = min
  end
  if bool and num < max then
    if num + (max-num) * scalar > max then
      return max
    else
      return num + (max-num) * scalar
    end
  elseif not bool and num > min then
    return num + (min-num) * scalar
  else
    return num
  end
end

graphics.mix_colors = function(colortable)
  local newcolor = {1, 1, 1}
  for i, v in ipairs(colortable) do
    for j = 1, 3 do
      newcolor[j] = newcolor[j] * v[j]
    end
  end
  for i = 1, 3 do
    newcolor[i] = newcolor[i] / (255 * (#colortable-1))
  end
  return newcolor
end

return graphics
