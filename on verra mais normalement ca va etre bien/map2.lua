
map2 = {}


local img = love.graphics.newImage("images/bonomheu.png")
local bcgd = love.graphics.newImage("images/tn.jpg")
local bitd2 = love.graphics.newImage("images/bitd2.png")
local tree = love.graphics.newImage("images/trriie.png")
--quad = love.graphics.newQuad(0,0,200,200,img:getWidth(),img:getHeight())
map2.player2 = Player(15,10,img,2,4,2)

map2.map  = Map(map2.player2,40,40,13,7,100,true)
map2.map2 = Map(map2.player2,40,40,13,7,100,false,bcgd)
map2.map3 = Map(map2.player2,40,40,13,7,100,false)


p = function() print("caca") end
map2.map2.list[5][5].obj = objOuPnj(bitd2,4,4,3,p)
map2.map.list[5][6].obj = objOuPnj(bitd2,4,4,3,p)
map2.map3.list[5][7].obj = objOuPnj(bitd2,4,4,3,p)

function map2.update(dt)
  map2.map2.update(dt)
  map2.map.update(dt)
  map2.map3.update(dt)
  map2.player2.move(map2.map)
  map2.player2.interact(map2.map)
  map2.player2.updateMove(dt,5)
end 


function map2.draw()
  map2.map2.background()
  map2.map2.draw()
  map2.map.background()
  map2.map.draw()
  map2.map3.background()
  map2.map3.draw()
end


return map2