policymon = widget({type = "textbox", name = "policymon", align = "right"})
function policy_status ()
  local fd = io.popen("cpufreq-info -m -c0 -p", "r")
  local line = fd:read()
  local min_f, max_f, policy = string.match(line, "(%d+) (%d+) (.+)")
  min_f = math.ceil(min_f/10000)/100
  max_f = math.ceil(max_f/10000)/100
  return string.format(" %.02f-%.02f %.4s ", min_f, max_f, policy)
end

function policymon_signal()
  policymon.text = policy_status()
end

policymon_signal()

mypolicytimer = timer({ timeout = 8 })
mypolicytimer:add_signal("timeout", policymon_signal)
mypolicytimer:start()
