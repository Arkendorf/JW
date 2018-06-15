local shader = {}
--
shader.cloud_shadow = love.graphics.newShader[[
    extern Image game;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 cloud_pixel = Texel(texture, texture_coords);
      if(texture_coords.y-0.1 > 0.0){
        vec4 game_pixel = Texel(game, vec2(texture_coords.x, texture_coords.y-0.1));
        if(game_pixel.a == 1.0 && cloud_pixel == vec4(1.0, 1.0, 1.0, 1.0)){
          return color;
        }
      }
      return cloud_pixel;
    }
  ]]

shader.fill = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords);
      if(pixel.a == 1.0){
        return color;
      }
      return vec4(0.0, 0.0, 0.0, 0.0);
    }
  ]]

shader.shadow = love.graphics.newShader[[
    extern Image background;
    extern vec2 offset;
    extern vec2 screen;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords);
      if(pixel.a == 1.0){
        vec4 back_pixel = Texel(background, vec2((screen_coords.x-offset.x)/screen.x, (screen_coords.y-offset.y)/screen.y));
        if(back_pixel.r > back_pixel.g){
          return vec4(0.0, 0.0, 0.0, 0.0);
        }
        else if(back_pixel.g < back_pixel.b){
          return vec4(0.0, 132.0/255.0, 204.0/255.0, 1.0);
        }
        else {
          return vec4(0.0, 127.0/255.0, 33.0/255.0, 1.0);
        }
      }
      return vec4(0.0, 0.0, 0.0, 0.0);
    }
  ]]

return shader
