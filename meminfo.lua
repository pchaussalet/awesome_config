mymeminfo = widget({ type = "textbox", align = "right" })
function activeram()
    local active
    for line in io.lines('/proc/meminfo') do
        for key, value in string.gmatch(line, "(%w+):\ +(%d+).+") do
            if key == "Active" then active = tonumber(value) end
        end
    end

    return string.format(" %5dMB ",(active/1024))
end

function memmon_signal()
  mymeminfo.text = activeram()
end

memmon_signal()

mymemtimer = timer({ timeout = 8 })
mymemtimer:add_signal("timeout", memmon_signal)
mymemtimer:start()
