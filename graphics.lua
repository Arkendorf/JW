local graphics = {}

graphics.load = function()
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  font = love.graphics.newImageFont("font.png",
  " ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
  "abcdefghijklmnopqrstuvwxyz" ..
  "0123456789!?.:", 1)
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

  -- canvases
  canvas = {}
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

return graphics
