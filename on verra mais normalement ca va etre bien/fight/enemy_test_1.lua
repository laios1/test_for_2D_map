require('biblio')
local phases = {}
local imgP1 = love.graphics.newImage("images/jeff.png")

function updt1f()
  local updt1 = {}
  updt1.timer = 0
  updt1.d = "d"
  
  function updt1.updt(dt,e)
    if updt1.d == "d" then 
      e.x = e.x+1 
    elseif updt1.d == "g" then
      e.x = e.x-1 
    end 
    if e.x + e.w >= 800 then
      updt1.d = "g"
    elseif e.x <= 0 then
      updt1.d = "d"
    end 
    
    if updt1.timer > 5 then
     -- proj.add(,e.y+imgP1:getHeight()/3,0,10,"ally",3,20)
      proj.add(e.x+ imgP1:getWidth()/(14*2),e.y+imgP1:getHeight()/3,0,300,"enemy",10,10)
      updt1.timer = 0
    end  
  end 
  return updt1
end 

phases[1] = enemyPhase((love.graphics.getWidth()-imgP1:getWidth()/14)/2,5,updt1f,1,imgP1,3,14,0.3)


return phases