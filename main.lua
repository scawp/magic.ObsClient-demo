if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";lib/?.lua;lib/?/init.lua")

local urutora = require('urutora'):new()
local demo = require 'demo'
local host, port = demo:loadSettings()
local obsClient = require('obsClient').new(host, port)

function love.load()
  demo:init(urutora, obsClient)
end

function love.update(dt)
  obsClient:update(dt)
  demo:update(dt)
end

function love.draw()
  demo:draw()
end

function love.resize()
  demo:resize()
end

function love.mousepressed(x, y, button) urutora:pressed(x, y) end
function love.mousemoved(x, y, dx, dy) urutora:moved(x, y, dx, dy) end
function love.mousereleased(x, y, button) urutora:released(x, y) end
function love.textinput(text) urutora:textinput(text) end
function love.wheelmoved(x, y) urutora:wheelmoved(x, y) end
function love.keypressed(k, scancode, isrepeat)
  urutora:keypressed(k, scancode, isrepeat)

  if k == 'escape' then
    love.event.quit()
  end
end