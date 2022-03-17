

function Map(player,nbligne,nbcolonne,visibleX,visibleY,size,mapduplayer,backgroundimg)
  love.window.setMode(visibleX*size,visibleY*size)
  local spot = function ()
    local Cspot = {}
    Cspot.obj = nil 
    function Cspot.update(dt)
      
      if type(Cspot.obj) ~= "nil" then
        Cspot.obj.timer = Cspot.obj.timer + dt
        
        if Cspot.obj.timer >= 1/Cspot.obj.fps then
        Cspot.obj.timer = 0 
        if type(Cspot.obj.anim) ~= "nil" then
          Cspot.obj.anim(dt)
        end
        if type(Cspot.obj.update) ~= "nil" then
          Cspot.obj.update(dt)
        end
        
        end
      end 
    end 
    
    
    function Cspot.draw(unx,uny,unw,unh)
      
     -- love.graphics.rectangle("line",unx*unw-player.cam.sx,uny*unh-player.cam.sy,unw,unh)
      
      if type(Cspot.obj) ~= "nil" and type(Cspot.obj.draw) ~= "nil" then
        Cspot.obj.draw(unx,uny,unw,unh,player.cam.sx,player.cam.sy)
      end 
    end 
    
    return Cspot
  end

  

  local myMap = {} 
  myMap.player = player
  myMap.size = size
  myMap.nbligne = nbligne
  myMap.nbcolonne = nbcolonne
  myMap.list = {}
  for i = 1, nbligne do
    myMap.list[#myMap.list+1] = {}
    for j = 1, nbcolonne do
      myMap.list[i][j] = spot(i,j)
    end
  end
  if mapduplayer then
    myMap.list[player.x][player.y].obj = player
  end
  
  myMap.visibleX = visibleX
  myMap.visibleY = visibleY
  
  function myMap.update(dt)
    for i = 1, myMap.visibleX do
      for j = 1,myMap.visibleY do
        myMap.list[myMap.player.cam.x + i-math.ceil(myMap.visibleX/2)][myMap.player.cam.y + j-math.ceil(myMap.visibleY/2)].update(dt)
      end
    end
  end 
  
  
  myMap.bcgdImg = backgroundimg or nil
  
 -- myMap.bcgdQuad = love.graphics.newQuad(size*(player.cam.x-4),size*(player.cam.y-4),size*visibleX,size*visibleY,myMap.bcgdImg:getWidth(),myMap.bcgdImg:getHeight())
  
  
  
  function myMap.background()
    
    if type(myMap.bcgdImg) ~= "nil" then
      myMap.bcgdQuad = love.graphics.newQuad(size*(player.cam.x-4)+player.cam.sx,size*(player.cam.y-4)+player.cam.sy,size*visibleX,size*visibleY,myMap.bcgdImg:getWidth(),myMap.bcgdImg:getHeight())
      
      love.graphics.draw(myMap.bcgdImg,myMap.bcgdQuad,0,0,0,1,1)
    end
  end 
  
  
  
  function myMap.draw()
    for j = 1,myMap.visibleY+2 do
      for i = 1, myMap.visibleX+2 do
        if type(myMap.list[myMap.player.cam.x + i-math.ceil(myMap.visibleX/2)-1]) ~= "nil" and  type(myMap.list[myMap.player.cam.x + i-math.ceil(myMap.visibleX/2)-1][myMap.player.cam.y + j-math.ceil(myMap.visibleY/2)-1]) ~= "nil" then
        myMap.list[myMap.player.cam.x + i-math.ceil(myMap.visibleX/2)-1][myMap.player.cam.y + j-math.ceil(myMap.visibleY/2)-1].draw((i-2),(j-2),size,size)
        end
      end
    end
  end 
  
  return myMap
end

function objOuPnj(img,nbf,nbe,etat,interaction,updt,fps)-- etats (son regard): bas haut droite gauche ... et puls si besoin 
  local monObj = {}
  monObj.etat = etat or 1 
  monObj.img = img
  monObj.quadDimention = {}
    monObj.quadDimention.x = 0
    monObj.quadDimention.y = 0
    monObj.quadDimention.w = monObj.img:getWidth()/nbf
    monObj.quadDimention.h = monObj.img:getHeight()/nbe
  monObj.cFrame = 1
  monObj.tFrame = nbf
  monObj.quad = love.graphics.newQuad(monObj.quadDimention.w*(monObj.cFrame-1),monObj.quadDimention.h*(monObj.etat-1),monObj.quadDimention.w,monObj.quadDimention.h,monObj.img:getWidth(),monObj.img:getHeight())
  
  monObj.fps = fps or 5  
  monObj.timer = 0
  
  monObj.update = updt or nil
  
  
  function monObj.changeEtat(e,tf)
    monObj.etat = e
    monObj.cFrame = 1
  end 
 -- monObj.isInteract = false
  monObj.interact = interaction or function() end
  
  function monObj.anim(dt)
    monObj.cFrame = changeUntilYouCant(monObj.cFrame,1,monObj.tFrame,1)
    monObj.quad = love.graphics.newQuad(monObj.quadDimention.w*(monObj.cFrame-1),monObj.quadDimention.h*(monObj.etat-1),monObj.quadDimention.w,monObj.quadDimention.h,monObj.img:getWidth(),monObj.img:getHeight())
  end 
  
  function monObj.draw(posX,posY,w,h,csx,csy)
    love.graphics.draw(monObj.img,monObj.quad,posX*w+w/2-csx, posY*h+h-csy,0,1,1,monObj.quadDimention.w/2,monObj.quadDimention.h)
    
--    if monObj.isInteract then
--      monObj.isInteract = monObj.interact()
--    end
  end
  
  return monObj
end 



function Player(x,y,img,nbf,nbe,nba,etat,action,fps)-- etats (son regard): bas haut droite gauche ... et plus si besoin /// mouvementTypes{walk = 2, jump = 3,...} //////     action : 0 = rien , 1 = walk , 3 = ? 
  local player = {}
  player.x = x
  player.y = y
  player.cam = {}
  player.cam.x = x
  player.cam.y = y
  player.cam.sx = 0
  player.cam.sy = 0
  player.cam.z = false
  player.cam.s = false
  player.cam.d = false
  player.cam.q = false
  
  player.visx = visix
  player.visy = visiy
  
  player.ti = 0 
--  player.curo = {}
--  player.curo.isInteract = false
  
  player.etat = etat or 1 
  player.nbetat = nbe
  
  player.img = img
  player.quadDimention = {}
    player.quadDimention.x = 0
    player.quadDimention.y = 0
    player.quadDimention.w = player.img:getWidth()/nbf
    player.quadDimention.h = player.img:getHeight()/(nbe*nba)
  player.cFrame = 1
  player.tFrame = nbf
  
  player.action = action or 0
  player.taction = nba
  
  player.ismoving = {}
  player.ismoving.z = false
  player.ismoving.s = false
  player.ismoving.d = false
  player.ismoving.q = false
  player.ismoving.var = 0
  player.ismoving.mw = 0
  player.ismoving.mh = 0 
  
  player.quad = love.graphics.newQuad(player.quadDimention.w*(player.cFrame-1),player.quadDimention.h*(player.etat-1),player.quadDimention.w,player.quadDimention.h,player.img:getWidth(),player.img:getHeight())
  
  
  player.fps = fps or 5
  player.timer = 0

  function player.changeEtat(e)
    player.etat = e
    player.cFrame = 1
  end 
  
  
  function player.anim(dt)
      player.quad = love.graphics.newQuad(player.quadDimention.w*(player.cFrame-1),player.quadDimention.h*((player.etat-1)+player.action*player.nbetat),player.quadDimention.w,player.quadDimention.h,player.img:getWidth(),player.img:getHeight())
      if player.cFrame >= player.tFrame then
        player.action = 0 
      end 
      player.cFrame = changeUntilYouCant(player.cFrame,1,player.tFrame,1)
    
  end 
  
  function player.updateMove(dt,s)
    if player.ismoving.z then 
      player.ismoving.var = player.ismoving.var - (player.ismoving.mh/player.tFrame) *dt*s
     -- player.cam.sy = player.cam.sy - (player.ismoving.mh/player.tFrame) *dt*s 
      if player.ismoving.var <= 0 then 
        player.ismoving.z = false
      end 
    elseif player.ismoving.s then 
      player.ismoving.var = player.ismoving.var - (player.ismoving.mh/player.tFrame)*dt*s
     -- player.cam.sy = player.cam.sy + (player.ismoving.mh/player.tFrame) *dt*s 
      if player.ismoving.var <= 0 then 
        player.ismoving.s = false
      end   
      
    elseif player.ismoving.d then 
      player.ismoving.var = player.ismoving.var - (player.ismoving.mw/player.tFrame)*dt*s
      --player.cam.sy = player.cam.sx - (player.ismoving.mh/player.tFrame) *dt*s 
      if player.ismoving.var <= 0 then 
        player.ismoving.d = false
      end 
      
    elseif player.ismoving.q then 
      player.ismoving.var = player.ismoving.var - (player.ismoving.mw/player.tFrame)*dt*s
      --player.cam.sy = player.cam.sx + (player.ismoving.mh/player.tFrame) *dt*s 
      if player.ismoving.var <= 0 then 
        player.ismoving.q = false
      end 
    end
    
    
    
    
    
    
    
    if player.cam.z then 
     player.cam.sy = player.cam.sy - (player.ismoving.mh/player.tFrame) *dt*s 
     player.cam.sy = math.max(player.cam.sy,0)
      if player.cam.sy <= 0 then 
        player.cam.z = false
      end 
    elseif player.cam.s then 
      player.cam.sy = player.cam.sy + (player.ismoving.mh/player.tFrame) *dt*s 
      player.cam.sy = math.min(player.cam.sy,0)
      if player.cam.sy >= 0 then 
        player.cam.s = false
      end   
      
    elseif player.cam.d then 
      player.cam.sx = player.cam.sx + (player.ismoving.mw/player.tFrame) *dt*s 
      player.cam.sx = math.min(player.cam.sx,0)
      if player.cam.sx >= 0 then 
        player.cam.d = false
      end 
      
    elseif player.cam.q then 
      player.cam.sx = player.cam.sx - (player.ismoving.mw/player.tFrame) *dt*s 
      player.cam.sx = math.max(player.cam.sx,0)
      if player.cam.sx <= 0 then 
        player.cam.q = false
      end 
    end
    
    player.ti = player.ti + dt
  end
  
  function player.draw(posX,posY,w,h)
    if player.ismoving.z then 
      love.graphics.draw(player.img,player.quad,posX*w + w/2, posY*h + h + player.ismoving.var,0,1,1,player.quadDimention.w/2,player.quadDimention.h)
    elseif player.ismoving.s then 
      love.graphics.draw(player.img,player.quad,posX*w + w/2, posY*h + h - player.ismoving.var,0,1,1,player.quadDimention.w/2,player.quadDimention.h)
    elseif player.ismoving.d then 
      love.graphics.draw(player.img,player.quad,posX*w + w/2 - player.ismoving.var, posY*h + h ,0,1,1,player.quadDimention.w/2,player.quadDimention.h)
    elseif player.ismoving.q then 
      love.graphics.draw(player.img,player.quad,posX*w + w/2 + player.ismoving.var, posY*h + h ,0,1,1,player.quadDimention.w/2,player.quadDimention.h)
    else
      love.graphics.draw(player.img,player.quad,posX*w + w/2, posY*h + h,0,1,1,player.quadDimention.w/2,player.quadDimention.h)
    end
--    print("z = "..tostring(player.cam.z))
--    print("s = "..tostring(player.cam.s))
--    print("d = "..tostring(player.cam.d))
--    print("q = "..tostring(player.cam.q))
--    print("sy = ".. player.cam.sy)
--    print("sx = ".. player.cam.sx)
  end
  
  
  
  
  
  
  function player.move(map)
    player.ismoving.mw = map.size
    player.ismoving.mh = map.size 
    if love.keyboard.isDown("z") and player.ismoving.z == false and player.ismoving.s == false and player.ismoving.d == false and player.ismoving.q == false and player.cam.z == false and player.cam.s == false and player.cam.d == false and player.cam.q == false then
      player.changeEtat(2)
      if type(map.list[player.x][player.y-1]) ~= "nil" and type(map.list[player.x][player.y-1].obj) == "nil" then
        
        map.list[player.x][player.y].obj = nil
        map.list[player.x][player.y-1].obj = player
        
        player.ismoving.var = map.size
        player.ismoving.z = true 
        
        player.y = player.y-1
        if player.taction > 1 then
          player.action = 1
        end 
        if player.cam.y > math.ceil(map.visibleY/2) and player.y == player.cam.y -1 then
          player.cam.y = player.cam.y-1
          player.cam.sy = map.size
          player.cam.z = true
          player.ismoving.var = 0
          player.ismoving.z = false
        end
        
      end
    end 
    if love.keyboard.isDown("s") and player.ismoving.z == false and player.ismoving.s == false and player.ismoving.d == false and player.ismoving.q == false and player.cam.z == false and player.cam.s == false and player.cam.d == false and player.cam.q == false then
      player.changeEtat(1)
      if type(map.list[player.x][player.y+1]) ~= "nil" and type(map.list[player.x][player.y+1].obj) == "nil" then
        
        map.list[player.x][player.y].obj = nil
        map.list[player.x][player.y+1].obj = player
        
        player.ismoving.var = map.size
        player.ismoving.s = true 
        
        player.y = player.y+1
        if player.taction > 1 then
          player.action = 1
        end 
        if player.cam.y <= map.nbcolonne-math.ceil(map.visibleY/2) and player.y == player.cam.y+1 then
          player.cam.y = player.cam.y+1
          player.cam.sy = -map.size
          player.cam.s = true
          player.ismoving.var = 0
          player.ismoving.s = false
        end
        
      end
    end 
   
    if love.keyboard.isDown("q") and player.ismoving.z == false and player.ismoving.s == false and player.ismoving.d == false and player.ismoving.q == false and player.cam.z == false and player.cam.s == false and player.cam.d == false and player.cam.q == false then
      player.changeEtat(4)
      if type(map.list[player.x-1]) ~= "nil" and type(map.list[player.x-1][player.y].obj) == "nil" then
        map.list[player.x][player.y].obj = nil
        map.list[player.x-1][player.y].obj = player
        
        player.ismoving.var = map.size
        player.ismoving.q = true 
        
        player.x = player.x-1
        
        if player.taction > 1 then
          player.action = 1
        end 
        if player.cam.x > math.ceil(map.visibleX/2) and player.x == player.cam.x-1 then
          player.cam.x = player.cam.x-1
          player.cam.sx = map.size
          player.cam.q = true
          player.ismoving.var = 0
          player.ismoving.q = false
        end
        
      end
    end 
    if love.keyboard.isDown("d") and player.ismoving.z == false and player.ismoving.s == false and player.ismoving.d == false and player.ismoving.q == false and player.cam.z == false and player.cam.s == false and player.cam.d == false and player.cam.q == false then
      player.changeEtat(3)
      if type(map.list[player.x+1]) ~= "nil" and type(map.list[player.x+1][player.y].obj) == "nil" then
        map.list[player.x][player.y].obj = nil
        map.list[player.x+1][player.y].obj = player
        
        player.ismoving.var = map.size
        player.ismoving.d = true 
        
        
        player.x = player.x+1
        
        if player.taction > 1 then
          player.action = 1
        end 
        if player.cam.x <= map.nbligne-math.ceil(map.visibleX/2) and player.x == player.cam.x+1 then
          player.cam.x = player.cam.x+1
          player.cam.sx = -map.size
          player.cam.d = true
          player.ismoving.var = 0
          player.ismoving.d = false
        end
      end
    end 
  end
  
  function player.interact(map)
    if love.keyboard.isDown("e") and player.ismoving.z == false and player.ismoving.s == false and player.ismoving.d == false and player.ismoving.q == false and player.cam.z == false and player.cam.s == false and player.cam.d == false and player.cam.q == false and player.ti >= 0.2  then
      
      if player.etat == 1 and type(map.list[player.x][player.y+1]) ~= "nil" and  type(map.list[player.x][player.y+1].obj) ~= "nil" then 
--        map.list[player.x][player.y+1].obj.isInteract = true
--        player.curo = map.list[player.x][player.y+1].obj
        map.list[player.x][player.y+1].obj.interact()
      end
      if player.etat == 2 and type(map.list[player.x][player.y-1]) ~= "nil" and  type(map.list[player.x][player.y-1].obj) ~= "nil" then 
--        map.list[player.x][player.y-1].obj.isInteract = true
--        player.curo = map.list[player.x][player.y-1].obj
        map.list[player.x][player.y-1].obj.interact()
      end
      if player.etat == 3 and type(map.list[player.x+1][player.y]) ~= "nil" and  type(map.list[player.x+1][player.y].obj) ~= "nil" then 
--        map.list[player.x+1][player.y].obj.isInteract = true
--        player.curo = map.list[player.x+1][player.y].obj
        map.list[player.x+1][player.y].obj.interact()
      end
      if player.etat == 4 and type(map.list[player.x-1][player.y]) ~= "nil" and  type(map.list[player.x-1][player.y].obj) ~= "nil" then 
--        map.list[player.x-1][player.y].obj.isInteract = true
--        player.curo = map.list[player.x-1][player.y].obj
        map.list[player.x-1][player.y].obj.interact()
      end
      
      player.ti = 0 
    end 
  end
  return player
end 
  
  
  function changeUntilYouCant(v,o,l,i)
  if i > 0 then
    if v >= l then 
      v = o 
    else
      v = v + i 
    end
  elseif i < 0 then
    if v <= l then 
      v = o 
    else
      v = v + i 
    end
  end
    
  return v
end 


function dialogues(x,y,w,h,bcgd,tc,po)
  local di = {}
  di.x = x
  di.y = y 
  di.w = w
  di.h = h 
  di.bcgd = bcgd
  di.tc = tc 
  di.police = po
  di.list_of_txt = {}
  di.i = 1
  di.timer = 0
  di.isRunning = false
  
  
  
  function di.draw()
    love.graphics.setNewFont(34)
    if type(di.bcgd) == "table" and di.isRunning then
      love.graphics.setColor(di.bcgd)
      love.graphics.rectangle("fill",di.x,di.y,di.w,di.h)
      love.graphics.setColor(di.tc)
      love.graphics.printf(di.list_of_txt[di.i],di.x,di.y--[[+di.h/2]],di.w,"center")
    elseif di.isRunning then
      love.graphics.setColor(1,1,1)
      love.graphics.draw(di.bcgd,di.x,di.h,0,di.w/di.bcgd:getWidth(),di.h/di.bcgd:getHeight())
      love.graphics.setColor(di.tc)
      love.graphics.printf(di.list_of_txt[di.i],di.x,di.y--[[+di.h/2]],di.w,"center")
    end
    love.graphics.setColor(1,1,1)
  end
  
  function di.update()
--    di.timer = di.timer + dt
--    if di.isRunning then
--      if love.keyboard.isDown("e") and di.timer > 0.5 and #di.list_of_txt > 0 then
--        if di.i >= #di.list_of_txt then
--          di.i = 1 
--          di.list_of_txt = {}
--          di.isRunning = false
--        else
--          di.i = di.i + 1
--        end 
--        di.timer = 0
--      end 
--    end
    
    if di.i >= #di.list_of_txt then
      di.i = 1 
      di.list_of_txt = {}
      di.isRunning = false
    else
      di.i = di.i + 1
    end 
    
  end
  
  
  function di.add(txtt,cl)
    if di.isRunning == false then
      di.tc = cl or di.tc
      di.isRunning = true
      if type(txtt) == "table" then
        di.list_of_txt = txtt
      else
        di.list_of_txt[#di.list_of_txt+1] = txtt
      end 
    end
  end
  return di
end
