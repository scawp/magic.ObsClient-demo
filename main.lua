if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";lib/?.lua")

local obsClient = require 'obsClient'

local magicDebug = require 'tools.magicDebug'

function love.load()
  --magicDebug.parse_event_functions_from_file("1events.txt")

  obsClient:init()

  obsClient:GetSceneList()
end

obsClient.GetSceneList = function(self)
  local params = {
    ["request-type"] = "GetSceneList",
    ["callback_func"] = "GetSceneListCallBack"
  }
  self:sendObsRequest(params)

 end

obsClient.GetSceneListCallBack = function(self, data)
  self:log("Getting Current Scene \"" .. data["current-scene"] .. "\"", "Callback")
  scene_name_text_ui:set("Current Scene: HUZZAH " .. data["current-scene"])
end

function love.update(dt)
  obsClient:update(dt)
end

scene_name_text_ui = love.graphics.newText(love.graphics.getFont(), "Current Scene: No Data" )

obsClient.SwitchScenes = function(self, data)
  self:log("Running SwitchScenes \"" .. data["scene-name"] .. "\"", "Success")
  scene_name_text_ui:set("Current Scene: " .. data["scene-name"])
end

function love.draw()
  local new_line_start, margin = 10, 10
  love.graphics.draw(scene_name_text_ui, margin, new_line_start )
  new_line_start = new_line_start + scene_name_text_ui:getHeight() + 5
  --love.graphics.draw(scene_name_text_ui, margin, new_line_start )
end



local obsCallbackHandler = {
  update = function()

  end
}

function love.keypressed(key)
  print("change scene key:" .. key)
  if (key == "1") then
    --scene 1
  elseif (key == "2") then
    --scene 2
  end
end