mybattmon = widget({ type = "textbox", name = "mybattmon", align = "right" })
function battery_status ()
    local output={} --output buffer
    local fd=io.popen("acpi -b", "r") --list present batteries
    local line=fd:read()
    while line do --there might be several batteries.
      local battery_num = string.match(line, "Battery (%d+)")
      local battery_load = string.match(line, " (%d*)%%")
      local time_rem = string.match(line, "(%d+\:%d+)\:%d+")
      local discharging
      if string.match(line, "Discharging")=="Discharging" then --discharging: always red
        if tonumber(battery_load)<10 then
          discharging="<span color=\"#FF0000\">"
        else
          discharging="<span color=\"#FFFFFF\">"
        end
      elseif tonumber(battery_load)>85 then --almost charged
        discharging="<span color=\"#00CC00\">"
      else --charging
        discharging="<span color=\"#FF6600\">"
      end
      if battery_num and battery_load and time_rem then
        table.insert(output, discharging..battery_load.."% "..time_rem.."</span>")
      elseif battery_num and battery_load then --remaining time unavailable
        table.insert(output, discharging..battery_load.."%</span>")
      end --even more data unavailable: we might be getting an unexpected output format, so let's just skip this line.
      line=fd:read() --read next line
    end
    return table.concat(output," ") --FIXME: better separation for several batteries. maybe a pipe?
end
function battmon_signal()
  mybattmon.text = " " .. battery_status() .. " "
end
battmon_signal()
my_battmon_timer = timer({timeout=8})
my_battmon_timer:add_signal("timeout", battmon_signal)
my_battmon_timer:start()
