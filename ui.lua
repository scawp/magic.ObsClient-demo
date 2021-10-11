return {
  w = 0,
  h = 0,
  next_line_start = 0,
  button = {
    margin_x = 10,
    margin_y = 5,
    h = 50,
    w = 0
  },

  init = function(self)
    self:onResize()
    self:addButton()
    self:buildMenu()
    obsClient.requests:GetSceneList({["retry"] = true})
    obsClient.requests:GetVersion({["retry"] = true})


  end,

  buildMenu = function (self)
    self:addStartStopButtons()
  end,

  onResize = function (self)
    self.w, self.h = love.window.getMode()
    self.button.w = self.w - (self.button.margin_x * 2)
    --self.button.h = self.h / NUMBER_OF_ITEMS - (self.button.margin_h * 2)
    self.next_line_start = self.button.margin_y

  end,

  getNextLineStart = function (self)
    local this_line_start = self.next_line_start
    self.next_line_start = self.next_line_start + self.button.h + (self.button.margin_y * 2)
    return this_line_start
  end,

  addButton = function (self, params)
    params = params or {}
    local button = URUTORA.button({
      text = params.label or "none set",
      x = params.x or self.button.margin_x, 
      y = params.y or self:getNextLineStart(),
      w = params.w or self.button.w,
      h = params.h or self.button.h,
      num = 0
    })
  
    button:action(params.action or function(e)
      e.target.num = e.target.num + 1
      e.target.text = 'This button doesn\'t do anything'
    end)
  
    URUTORA:add(button)
  end,

  addStartStopButtons = function (self)
    self:addButton({label = "Start", 
                    y = self.h - self.button.h - (self.button.margin_y * 2),
                    w = self.button.w / 2,
                    action = function ()
                      obsClient:log("Start Recording ", "Button Click")
                      obsClient.requests:StartRecording()
                    end
    })
    
    self:addButton({label = "Stop", 
                    y = self.h - self.button.h - (self.button.margin_y * 2),
                    w = self.button.w / 2,
                    --TODO: math for x is wrong
                    x = (self.button.w / 2) + self.button.margin_x + 10,
                    action = function ()
                      obsClient:log("Stop Recording ", "Button Click")
                      obsClient.requests:StopRecording()
                    end
    })
  end
}
