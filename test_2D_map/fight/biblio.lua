-- teams : ally, enemy


function enemyPhase(x,y,u,cp,img,nbp,nbf,tpf,)
  local enemy = {}
  enemy.x , enemy.y = x,y 
  
  enemy.w, enemy.h = img:getWidth()/nbf,img:getHeight()/nbp
  
  

  enemy.updt = u()
  
  enemy.time = 0 
  
  enemy.cf = 1
  
  enemy.img = img
  
  enemy.quad = love.graphics.newQuad((enemy.cf-1)*(img:getWidth()/nbf),(cp-1)*(img:getHeight()/nbp),img:getWidth()/nbf,img:getHeight()/nbp,img:getWidth(),img:getHeight())
  
  function enemy.draw()
    love.graphics.draw(enemy.img,enemy.quad,enemy.x,enemy.y)
  end 
  
  function enemy.update(dt)
    enemy.time = enemy.time + dt
    if enemy.time >= tpf then
      enemy.cf = changeUntilYouCant(enemy.cf,1,nbf,1)
      enemy.time = 0
      enemy.quad = love.graphics.newQuad((enemy.cf-1)*(img:getWidth()/nbf),(cp-1)*(img:getHeight()/nbp),img:getWidth()/nbf,img:getHeight()/nbp,img:getWidth(),img:getHeight())
    end 
    enemy.updt.timer = enemy.updt.timer + 1
    enemy.updt.updt(dt,enemy)
  end 
  
  
  
  function enemy.getHit(allP)
    local ii = 1
    while ii <= #allP do
      if hitBC({enemy.x , enemy.y,enemy.w,enemy.h},{allP[ii].x,allP[ii].y,allP[ii].t}) and allP[ii].team ~= "enemy" then
        table.remove(allP,ii)
        ii = ii - 1
      end
      ii = ii + 1
    end
  end 
  
  return enemy
end 



function Enemy(phases)
  local myEnemy = {}
  
  
  myEnemy.CurPhase = 1
  
  
  
  
  function myEnemy.draw()
    phases[myEnemy.CurPhase].draw()
  end
  
  function myEnemy.update(dt,allP)
    phases[myEnemy.CurPhase].update(dt)
    phases[myEnemy.CurPhase].getHit(allP)
  end 
  return myEnemy
end 




function PlayerCombat(proj)
  local player = {}
  player.x , player.y = love.graphics.getDimensions()
  player.x , player.y = player.x/2 , player.y*6/8
  
  
  player.w, player.h = 5,10
  
  player.downCount = 0 
  
  player.nbBall = 0
  
  function player.draw()
    love.graphics.rectangle("fill",player.x , player.y,player.w,player.h)
  end
  
  function player.update(dt,allP)
--    player.x , player.y = player.x + player.vx * dt *5 , player.y + player.vy * dt *5
     player.getHit(allP)
  end
  
  
  
  function player.move()
    if love.keyboard.isDown("z") then
      player.y = player.y -1 - player.downCount
    end
    if love.keyboard.isDown("s") then
      player.y = player.y +1 + player.downCount
    end
    if love.keyboard.isDown("q") then
      player.x = player.x -1 - player.downCount
    end
    if love.keyboard.isDown("d") then
      player.x = player.x + 1 + player.downCount
    end
    if (love.keyboard.isDown("z") or love.keyboard.isDown("q") or love.keyboard.isDown("s") or love.keyboard.isDown("d")) then
      player.downCount = player.downCount + 0.2 
      player.downCount = math.min(player.downCount,10)
    end
    if not (love.keyboard.isDown("z") or love.keyboard.isDown("q") or love.keyboard.isDown("s") or love.keyboard.isDown("d")) then
      player.downCount = 0 
    end
  end
  
  function player.tir()
    if love.keyboard.isDown("space") then
      proj.add(player.x+2.5,player.y-10,0,-600,"ally",3,10)
      
      player.nbBall = player.nbBall + 1
    end 
  end
  
  function player.getHit(allP)
    local ii = 1
    while ii <= #allP do
      if hitBC({player.x , player.y,player.w,player.h},{allP[ii].x,allP[ii].y,allP[ii].t}) and allP[ii].team ~= "ally" then
        table.remove(allP,ii)
        ii = ii - 1
      end
      ii = ii + 1
    end
  end 
  
  return player
end



function projectiles()
  lesProj = {}
  lesProj.liste = {}
  
  
  function lesProj.draw()
    for i = 1,#lesProj.liste do
      if lesProj.liste[i].team == "ally" then
        love.graphics.setColor(0,0,1)
      elseif lesProj.liste[i].team == "enemy" then
        love.graphics.setColor(1,0,0)
      end 
      lesProj.liste[i].draw()
    end
    love.graphics.setColor(1,1,1)
  end 
  
  function lesProj.update(dt)
    local ii = 1
    while ii <= #lesProj.liste do
      if lesProj.liste[ii].timd >= lesProj.liste[ii].d then
        table.remove(lesProj.liste,ii)
       -- 
        ii = ii-1
      end
      ii = ii + 1
    end 
    for i = 1,#lesProj.liste do
      lesProj.liste[i].update(dt)
    end 
  end
  
  
  
  function lesProj.add(x,y,vx,vy,team,t,d,u,dessin)
    local unProj = {}
    unProj.x = x
    unProj.y = y 
    unProj.vx = vx
    unProj.vy = vy 
    unProj.d = d or 10000
    unProj.timd = 0 
    unProj.team = team
    
    if type(t) == "table" then
      unProj.w = t[1]
      unProj.h = t[2]
      unProj.r = t[3] or 0
      unProj.type = "rect"
    elseif type(t) == "number" then
      unProj.t = t 
      unProj.type = "rond"
    else
      unProj.t = 1 
      unProj.type = "rond"
    end 
    
    
    unProj.draw = dessin or function()
      if unProj.type == "rect" then
        love.graphics.rectangle("fill",unProj.x,unProj.y,unProj.w,unProj.h)
      else
        love.graphics.circle("fill",unProj.x,unProj.y,unProj.t)
      end 
    end 
    
    unProj.update = u or function(dt)
      unProj.x = unProj.x + unProj.vx * dt
      unProj.y = unProj.y + unProj.vy * dt 
      
      unProj.timd = unProj.timd + dt
    end 
    
    lesProj.liste[#lesProj.liste+1] = unProj
  end 
  
  return lesProj
end 



function hitBC(kare,rond)
  
  htbcKre = hitboxRect(kare[1]+kare[3]/2,kare[2]+kare[4]/2,kare[3],kare[4])
  
  for i = 1,#htbcKre do
    if ((htbcKre[i][1]-rond[1])^2 + (htbcKre[i][2]-rond[2])^2)^0.5 < rond[3] then
      return true 
    end 
  end 
  if rond[1] > kare[1] and rond[1] < kare[1] + kare[3] and rond[2] > kare[2] and rond[2] < kare[2] + kare[4] then
    return true 
  end 
  return false
  
  
--  if ((kare[1]-rond[1])^2 + (kare[2]-rond[2])^2)^0.5 < rond[3] then
--    return true
--  end 
--  if ((kare[1]+kare[3]/2-rond[1])^2 + (kare[2]-rond[2])^2)^0.5 < rond[3] then
--    return true
--  end
--  if ((kare[1]+kare[3]-rond[1])^2 + (kare[2]-rond[2])^2)^0.5 < rond[3] then
--    return true
--  end
--  if ((kare[1]-rond[1])^2 + (kare[2]+kare[4]/2-rond[2])^2)^0.5 < rond[3] then
--    return true
--  end
--  if ((kare[1]+kare[3]-rond[1])^2 + (kare[2]+kare[4]/2-rond[2])^2)^0.5 < rond[3] then
--    return true
--  end
--  if ((kare[1]-rond[1])^2 + (kare[2]+kare[4]-rond[2])^2)^0.5 < rond[3] then
--    return true
--  end
--  if ((kare[1]+kare[3]/2-rond[1])^2 + (kare[2]+kare[4]-rond[2])^2)^0.5 < rond[3] then
--    return true
--  end
--  if ((kare[1]+kare[3]-rond[1])^2 + (kare[2]+kare[4]-rond[2])^2)^0.5 < rond[3] then
--    return true
--  end
--  if rond[1] > kare[1] and rond[1] < kare[1] + kare[3] and rond[2] > kare[2] and rond[2] < kare[2] + kare[4] then
--    return true 
--  end 
--  return false
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





function hitboxRect(x,y,l,h,rot) -- fonction qui ne marche que si X et Y sont au milieux de la figure
  rot = rot or 0 
  local pts = {}
  local x1 =  x + math.cos(rot) * l/2
  local y1 =  y + math.sin(rot) * l/2
  pts[#pts+1] = {x1,y1}
  
  local x2 =  x + math.cos(math.pi + rot) * l/2
  local y2 =  y + math.sin(math.pi + rot) * l/2
  pts[#pts+1] = {x2,y2}
  
  local x3 =  x + math.cos(-math.pi/2 + rot) * h/2
  local y3 =  y + math.sin(-math.pi/2 + rot) * h/2
  pts[#pts+1] = {x3,y3}
  
  local x4 =  x + math.cos(math.pi/2 + rot) * h/2
  local y4 =  y + math.sin(math.pi/2 + rot) * h/2
  pts[#pts+1] = {x4,y4}
  
  
  local r = ((l/2)^2+(h/2)^2)^0.5
  
  local x5 = x + math.cos(math.atan((y3-y)/(x1-x))+rot) * r 
  local y5 = y + math.sin(math.atan((y3-y)/(x1-x))+rot) * r 
  pts[#pts+1] = {x5,y5}
  
  local x6 = x + math.cos(math.atan((y4-y)/(x1-x))+rot) * r 
  local y6 = y + math.sin(math.atan((y4-y)/(x1-x))+rot) * r 
  pts[#pts+1] = {x6,y6}
  
  
  local x7 = x + math.cos(math.atan((y3-y)/(x2-x))+rot+math.pi) * r
  local y7 = y + math.sin(math.atan((y3-y)/(x2-x))+rot+math.pi) * r
  pts[#pts+1] = {x7,y7}
  
  local x8 = x + math.cos(math.atan((y4-y)/(x2-x))+rot+math.pi) * r
  local y8 = y + math.sin(math.atan((y4-y)/(x2-x))+rot+math.pi) * r
  pts[#pts+1] = {x8,y8}
  
  return pts
end

