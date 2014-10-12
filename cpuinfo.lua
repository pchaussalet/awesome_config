mycpuinfo = widget({ type = "textbox", align = "right" })
function activecpu()
    local s = ""
    for line in io.lines("/proc/stat") do
        local cpu, newjiffies = string.match(line, "(cpu%d*)\ +(%d+)")
        if cpu and newjiffies then
            if not jiffies[cpu] then
                jiffies[cpu] = newjiffies
            end
            -- The string.format prevents your task list from jumping around when CPU usage goes above/below 10%
            s = s .. " " .. string.gsub(cpu, "cpu", "c") .. ":" .. string.format("%02d", (newjiffies-jiffies[cpu])/5) .. ""
            jiffies[cpu] = newjiffies
        end
    end
    return s
end
jiffies = {}

function cpumon_signal()
  mycpuinfo.text = activecpu() .. " "
end

cpumon_signal()
mycputimer = timer({ timeout = 4})
mycputimer:add_signal("timeout", cpumon_signal)
mycputimer:start()
