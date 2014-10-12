tempmon = widget({type = "textbox", name = "tempmon", align = "right"})
function temp_status ()
  local output = {}
  local fd = io.popen("sensors -A", "r")
  local line = fd:read()
  while line do
    local temp = string.match(line, "\+(%d+)")
    if temp then
      table.insert(output, temp .. "°C")
    end
    line = fd:read()
  end
  return table.concat(output, " ")
end

function tempmon_signal()
  tempmon.text = " " .. temp_status() .. " "
end

tempmon_signal()

mytemptimer = timer({ timeout = 8 })
mytemptimer:add_signal("timeout", tempmon_signal)
mytemptimer:start()
