freqmon = widget({type = "textbox", name = "freqmon", align = "right"})
function freq_status ()
  fd = io.open("/proc/cpuinfo")
  line = fd:read()
  local freqs = " "
  while line do
    if string.find(line, "cpu MHz") then
      freq = math.floor(tonumber(string.sub(line, 12) / 10)) / 100
      freqs = freqs .. string.format("%.02f ", freq)
    end
    line = fd:read()
  end
  return freqs
end

function freqmon_signal()
  freqmon.text = freq_status()
end

freqmon_signal()
myfreqtimer = timer({ timeout = 16 })
myfreqtimer:add_signal("timeout", freqmon_signal)
myfreqtimer:start()
