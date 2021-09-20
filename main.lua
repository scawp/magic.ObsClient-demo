love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";lib/?.lua")

local obs = require 'obsClient'

function love.load()
  obs:init()
end

function love.update(dt)
  obs:update(dt)
end

function love.draw()
end

function love.keypressed(key)
  print("change scene key:" .. key)
  if (key == "1") then
    --scene 1
  elseif (key == "2") then
    --scene 2
  end
end