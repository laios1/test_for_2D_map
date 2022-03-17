local map1 = {}



local img = love.graphics.newImage("images/bonomheu.png")
local bcgd = love.graphics.newImage("images/mapzse.jpg")
local burbd = love.graphics.newImage("images/burbd.png")
local tree = love.graphics.newImage("images/trriie.png")
local portal = love.graphics.newImage("images/portal.png")
--quad = love.graphics.newQuad(0,0,200,200,img:getWidth(),img:getHeight())
fsx,fsy = 700,700
dia = dialogues(0,fsy - fsy/5,fsx,fsy/5,{1,1,1},{1,0,0})

map1.player1 = Player(9,8,img,2,4,2)

map1.map = Map(map1.player1,2000,2000,7,7,100,true,bcgd)

function oe()
  if not dia.isRunning then
    dia.add({"bonjour","bbbooonnnjjjooouuurrr","bbbbbooooonnnnnjjjjjooooouuuuurrrrr","bbbbbbbbbboooooooooonnnnnnnnnnjjjjjjjjjjoooooooooouuuuuuuuuurrrrrrrrrr","bbbbbbbbbbbbbbbbbbbboooooooooooooooooooonnnnnnnnnnnnnnnnnnnnjjjjjjjjjjjjjjjjjjjjoooooooooooooooooooouuuuuuuuuuuuuuuuuuuurrrrrrrrrrrrrrrrrrrr"})
  else
    dia.update()
  end
end

function fischhhhhhhh()
  print("fschhhhhhhh")
  
end
function portail()
  currentMap = require("map2")
end



map1.map.list[16][2].obj = objOuPnj(portal,14,1,1,portail)

for i = 1,10 do
map1.map.list[i][4].obj = objOuPnj(tree,1,1,1,fischhhhhhhh)
end 
for i = 2,10 do 
  map1.map.list[15][i].obj = objOuPnj(burbd,4,4,3,oe)
  map1.map.list[17][i].obj = objOuPnj(burbd,4,4,1,oe)
end



function map1.update(dt)

  map1.map.update(dt)
--  for i = 2,10 do 
--    map1.map.list[15][i].obj.etat = changeUntilYouCant(map1.map.list[15][i].obj.etat,1,4,1)
--    map1.map.list[17][i].obj.etat = changeUntilYouCant(map1.map.list[17][i].obj.etat,1,4,1)
--  end

  if not dia.isRunning then
  map1.player1.move(map1.map)
  end
  map1.player1.interact(map1.map)
  map1.player1.updateMove(dt,5)
  
end 

function map1.draw()
  map1.map.background()
  map1.map.draw()
  dia.draw()
end 



return map1