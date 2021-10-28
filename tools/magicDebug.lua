return {
  parse_event_functions_from_file = function (filename)
    love.filesystem.remove("parse_event_functions_from_file.lua")
    for line in love.filesystem.lines(filename) do
      local func_name = string.match(line, '%+%s[%[](.*)[%]]')
      if func_name then
        local code = "self." .. func_name .. " = function()\n" ..
          "  --IOU some code\n" ..
          "end,\n\n"
        print(code)
        love.filesystem.append("parse_event_functions_from_file.lua", code)
       end
    end
  end
}