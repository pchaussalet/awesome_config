myvolmon = widget({ type = "textbox", name = "myvolmon", align = "right" })

function mute()
  io.popen("pactl set-sink-mute " .. sndcard .. " toggle")
  my_volmon_timer:emit_signal("timeout")
end

function volume_up()
  local old_volume = volume_status()
  if old_volume ~= "M" then
    set_volume(math.min(tonumber(old_volume) + 5, 100))
  end
end

function volume_down()
  local old_volume = volume_status()
  if old_volume ~= "M" then
    set_volume(math.max(tonumber(old_volume) - 5, 0))
  end
end

function set_volume(volume)
  local new_volume = tostring(volume) .. "%"
  io.popen("pactl set-sink-volume " .. sndcard .. " " ..  new_volume)
  my_volmon_timer:emit_signal("timeout")
end

function volume_status()
  local stdout = io.popen("pactl list sinks |sed 's/\t//' |egrep '^Mute|^Volume'")
  local status = stdout:read("*all")
  stdout:close()

  local mute = string.match(status, "Mute:.* (yes)")
  if mute == "yes" then
    return "M"
  else
    local volume = string.match(status, "Volume:.* (%d?%d?%d)%%.*")
    return volume
  end
end

function volmon_signal()
  local status = volume_status()
  if status ~= "M" then
    status = status .. "%"
  end
  myvolmon.text = string.format(" %4s ", status)
end

my_volmon_timer = timer({timeout=4})
my_volmon_timer:add_signal("timeout", volmon_signal)
my_volmon_timer:start()

volmon_signal()
my_volmon_timer:emit_signal("timeout")
