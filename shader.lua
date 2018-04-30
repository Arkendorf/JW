local shader = {}
--
shader.cloud_shadow = love.graphics.newShader[[
    extern Image game;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 cloud_pixel = Texel(texture, texture_coords);
      if(texture_coords.y-0.2 > 0.0){
        vec4 game_pixel = Texel(game, vec2(texture_coords.x, texture_coords.y-0.2));
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
    extern number x_offset;
    extern vec2 screen;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords);
      if(pixel.a == 1.0){
        vec4 back_pixel = Texel(background, vec2((screen_coords.x-x_offset)/screen.x, screen_coords.y/screen.y));
        if(back_pixel.g > back_pixel.b && back_pixel.g > 0.7){
          return vec4(62.0/255.0, 153.0/255.0, 29.0/255.0, 1.0);
        }
        else if(back_pixel.g > back_pixel.b && back_pixel.g < 0.7){
          return vec4(0.0, 102.0/255.0, 47.0/255.0, 1.0);
        }
        else if(back_pixel.g < back_pixel.b){
          return vec4(0.0, 68.0/255.0, 153.0/255.0, 1.0);
        }
      }
      return vec4(0.0, 0.0, 0.0, 0.0);
    }
  ]]

return shader
