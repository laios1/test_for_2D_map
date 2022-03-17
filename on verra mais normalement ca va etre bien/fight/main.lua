io.stdout:setvbuf('no')
require('biblio')
require('FuGrEtTa')

proj = projectiles()
p = PlayerCombat(proj)
e = Enemy(require('enemy_test_1'))
love.graphics.setBackgroundColor(0.5,0.5,0.5)
function love.draw()
  proj.draw()
  e.draw()
  p.draw()
  love.graphics.print(p.nbBall,0,0)
end

function love.update(dt)
  proj.update(dt)
  e.update(dt,proj.liste)
  p.update(dt,proj.liste)
  p.move()
  p.tir()
end


function love.keypressed(key)
  if key == "escape" then
    love.event.quit("restart")
  end 
end 
