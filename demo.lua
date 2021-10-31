return {
  u = nil,
  w = 360,
  h = 640,
  scale_x = 1,
  scale_y = 1,
  ui_canvas = nil,
  panels = {},


  init = function(self, urutora, obsClient)
    self.u = urutora
    self.obsClient = obsClient
    self.bgColor= self.u.utils.toRGB('#FF57BB')
    self.style = {
      fgColor = self.u.utils.toRGB('#fefefe'),
      bgColor = self.u.utils.toRGB('#7A306C'),
    }

    self:reset()
    --make canvas
    self.ui_canvas = love.graphics.newCanvas(self.w, self.h)
    --self.u.setDefaultFont(font1)
    self.u.setResolution(self.w, self.h)

    self:buildHeaderPanel()
    self:buildFooterPanel()
    self:getSceneList()

    self:addPanels()
  end,

  update = function (self, dt)
    self.u:update(dt)
  end,

  draw = function (self)
    love.graphics.setCanvas(self.ui_canvas)
      love.graphics.clear(self.bgColor)
      self.u:draw()
    love.graphics.setCanvas()
    love.graphics.clear(self.bgColor)
    --draw to screen
    love.graphics.draw(self.ui_canvas, 0, 0, 0, self.scale_x, self.scale_y)  
  end,

  resize = function (self)
    self.scale_x = love.graphics.getWidth() / self.ui_canvas:getWidth()
    self.scale_y = love.graphics.getHeight() / self.ui_canvas:getHeight()
    self.u.setResolution(self.w, self.h)
  end,

  loadSettings = function()
    local settings = {}
    if not love.filesystem.getInfo("Magic.conf") then
      return "localhost", "4444"
    end
    for line in love.filesystem.lines("Magic.conf") do
      table.insert(settings, line)
    end
    return settings[1], settings[2]
  end,

  saveSettings = function (self, url, port)
    love.filesystem.write("Magic.conf", url .. "\n")
    love.filesystem.append("Magic.conf", port)
  end,

  buildHeaderPanel = function (self)
    local panel = self.u.panel({tag = 'Pnl_Header',
                                rows = 3,
                                cols = 5,
                                x = 0, 
                                y = 10,
                                w = self.w, 
                                h = self.h / 5  })

    local lbl_current_scene = self.u.label({ text = 'Connected', tag = "Lbl_Status" })
    local txt_host = self.u.text({ text = self.obsClient.host })
    local txt_port = self.u.text({ text = tostring(self.obsClient.port) })
    
    panel
      :colspanAt(1, 1, 5)
      :colspanAt(2, 1, 4)
      :colspanAt(3, 2, 3)
      :addAt(1, 1, self.u.label({ text = 'mägic.obsClient Demo' }))
      --:addAt(1, 1, self.u.image({image = love.graphics.newImage('img/logo.png'), 
      --                      keep_aspect_ratio = true }))
      :addAt(2, 1, lbl_current_scene)
      :addAt(2, 5, self.u.button({ text = 'Save' }):action(function ()
        love.keyboard.setTextInput(true)
        self:saveSettings(txt_host.text, txt_port.text)
      end))
      :addAt(3, 1, self.u.label({ text = "Host:"}))
      :addAt(3, 2, txt_host)
      :addAt(3, 4, self.u.label({ text = "Port:"}))
      :addAt(3, 5, txt_port)
      :setStyle(self.style)


    self.obsClient:watchEvent("SwitchScenes", function (data)
        lbl_current_scene.text = "Current Scene: " .. data["scene-name"]
      end)

    self.panels["Header"] = panel
  end,

  buildFooterPanel = function (self)
    local panel = self.u.panel({tag = 'Pnl_Footer',
                           rows = 3, 
                           cols = 2, 
                           x = 0, 
                           y = self.h - (self.h / 5),
                           w = self.w, 
                           h = self.h / 5 })

    panel
      :addAt(1, 1, self.u.button({text = "Start Stream",
                            tag = "btn_start_stream"})
                            :action(function ()
                              self.obsClient:sendRequest("StartStreaming")
                            end))
      :addAt(1, 2, self.u.button({text = "Stop Stream",
                            tag = "btn_stop_stream"})
                            :action(function ()
                              self.obsClient:sendRequest("StopStreaming")
                            end))
      :addAt(2, 1, self.u.button({text = "Record",
                            tag = "btn_start_recording"})
                            :action(function ()
                              self.obsClient:sendRequest("StartRecording")
                            end))
      :addAt(2, 2, self.u.button({text = "End",
                            tag = "btn_stop_recording"})
                            :action(function ()
                              self.obsClient:sendRequest("StopRecording")
                            end))
      :setStyle(self.style)

    self.panels["Footer"] = panel
  end,

  buildScenesPanel = function (self, data)
    local panel = self.u.panel({tag = 'Pnl_Scenes',
                           rows = #data.scenes, 
                           cols = 1, 
                           x = 1, 
                           y = self.h - (self.h / 5) * 4,
                           csy = 50,
                           w = self.w -1, 
                           h = (self.h / 5) * 3 })

    --TODO: check for active scene and highlight
    for i, scene in ipairs(data.scenes) do
      panel:addAt(i, 1 , self.u.button({text = scene.name, 
                    tag = "Btn_Scene_" .. i})
                    :action(function ()
                      self.obsClient:sendRequest("SetCurrentScene", {["scene-name"] = scene.name})
                    end))
    end

    panel.outline = true
    --panel:setStyle({outlineColor = {1, 1, 1}})
    panel:setStyle(self.style)

    self.panels["Scenes"] = panel
    self.u:add(panel)
  end,

  getSceneList = function(self)
    self.obsClient:sendRequest("GetSceneList", 
                          true,
                          function(data)
                            self:buildScenesPanel(data)
                          end)
  end,

  reset = function (self)
    self.panels = {}
    self.u.nodes = {}
  end,

  addPanels = function (self)
  	for _, panel in pairs(self.panels) do
      self.u:add(panel)
    end
  end

}