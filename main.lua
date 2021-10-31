if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";lib/?.lua;lib/?/init.lua")

URUTORA = require('urutora'):new()
DEMO = require 'demo'

function loadSettings()
  local settings = {}
  if not love.filesystem.getInfo("Magic.conf") then
    return "localhost", "4444"
  end
  for line in love.filesystem.lines("Magic.conf") do
    table.insert(settings, line)
  end
  return settings[1], settings[2]
end

--move save to here

function love.load()
  --love.window.setFullscreen(true)

  local host, port = loadSettings()
  obsClient = require('obsClient').new(host, port)

  DEMO:init()
end

function love.update(dt)
  obsClient:update(dt)
  DEMO:update(dt)
end

function love.draw()
  DEMO:draw()
end

function love.resize()
  DEMO:resize()
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