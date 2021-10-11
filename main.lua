if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";lib/?.lua;lib/?/init.lua")

--temp fix for requests/events self call
OBSCLIENT = require 'obsClient'
--move this to menu or make local and inject?
URUTORA = require('urutora'):new()

MENU = require 'ui'

function love.load()
  obsClient = OBSCLIENT:new("localhost", 6666)
  obsClient:init()

  MENU:init()
end

function love.update(dt)
  obsClient:update(dt)
  URUTORA:update(dt)
end

function love.draw()
  URUTORA:draw()
end

function love.mousepressed(x, y, button) URUTORA:pressed(x, y) end
function love.mousemoved(x, y, dx, dy) URUTORA:moved(x, y, dx, dy) end
function love.mousereleased(x, y, button) URUTORA:released(x, y) end
function love.textinput(text) URUTORA:textinput(text) end
function love.wheelmoved(x, y) URUTORA:wheelmoved(x, y) end

function love.keypressed(k, scancode, isrepeat)
  URUTORA:keypressed(k, scancode, isrepeat)

  if k == 'escape' then
    love.event.quit()
  end
end