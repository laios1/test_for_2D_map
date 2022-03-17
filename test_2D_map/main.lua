io.stdout:setvbuf('no')
require('biblio')

currentMap = require("map1")


function love.update(dt)
  currentMap.update(dt)
end 

function love.draw()
  currentMap.draw()
end 


function love.keypressed(key)
  if key == "escape" then
    love.event.quit("restart")
  end 
end 

