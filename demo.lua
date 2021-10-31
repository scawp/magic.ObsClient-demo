return {
  u = URUTORA, --inject this
  w = 360, --720,--360,
  h = 640, --1280,--640,
  scale_x = 1,
  scale_y = 1,
  ui_canvas,
  panels = {},
  --bgColor = {45 / 255, 45 / 255, 45 / 255},
  bgColor= URUTORA.utils.toRGB('#FF57BB'),
  style = { 
    --fgColor = {45 / 255, 45 / 255, 45 / 255},
    fgColor = URUTORA.utils.toRGB('#fefefe'),
    --bgColor = {245 / 255, 185 / 255, 200 / 255}, 
    bgColor = URUTORA.utils.toRGB('#7A306C'),
--   hoverbgColor = URUTORA.utils.toRGB('#e3e3ef'),
--    hoverfgColor = URUTORA.utils.toRGB('#148ee3'),
--    disablefgColor = URUTORA.utils.toRGB('#ffffff'),
--    disablebgColor = URUTORA.utils.toRGB('#cccccc'),
--    outlineColor = URUTORA.utils.toRGB('#aaaaaa')
  },

  init = function(self)
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

  saveSettings = function (self, url, port)
    love.filesystem.write("Magic.conf", url .. "\n")
    love.filesystem.append("Magic.conf", port)
  end,

  buildHeaderPanel = function (self)
    local panel = self.u.panel({tag = 'Pnl_Header',
                                rows = 3,
                                cols = 5,
                                x = 0, 
                                y = 10, --Damn Camera Hole 
                                w = self.w, 
                                h = self.h / 5  })

    local lbl_current_scene = self.u.label({ text = 'Connected', tag = "Lbl_Status" })
    local txt_host = self.u.text({ text = obsClient.host }):action(function() love.keyboard.setTextInput(false) end)
    local txt_port = self.u.text({ text = tostring(obsClient.port) })
    
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


    obsClient:watchEvent("SwitchScenes", function (data)
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
                              obsClient:sendRequest("StartStreaming")
                            end))
      :addAt(1, 2, self.u.button({text = "Stop Stream",
                            tag = "btn_stop_stream"})
                            :action(function ()
                              obsClient:sendRequest("StopStreaming")
                            end))
      :addAt(2, 1, self.u.button({text = "Record",
                            tag = "btn_start_recording"})
                            :action(function ()
                              obsClient:sendRequest("StartRecording")
                            end))
      :addAt(2, 2, self.u.button({text = "End",
                            tag = "btn_stop_recording"})
                            :action(function ()
                              obsClient:sendRequest("StopRecording")
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
                      obsClient:sendRequest("SetCurrentScene", {["scene-name"] = scene.name})
                    end))
    end

    panel.outline = true
    --panel:setStyle({outlineColor = {1, 1, 1}})
    panel:setStyle(self.style)

    self.panels["Scenes"] = panel
    self.u:add(panel)
  end,

  getSceneList = function(self)
    obsClient:sendRequest("GetSceneList", 
                          true,
                          function(data)
                            self:buildScenesPanel(data)
                          end)
  end,

  reset = function (self)
    self.panels = {}
    URUTORA.nodes = {}
  end,

  addPanels = function (self)
  	for _, panel in pairs(self.panels) do
      self.u:add(panel)
    end
  end

}