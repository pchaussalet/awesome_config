cardid = 0
devicename = "pulse"
channel = "Master"

function volume (mode, widget)
  if mode == "update" then
--    local fd = io.popen("amixer -c " .. cardid .. " -- sget " .. channel)
    local fd = io.popen("amixer -D " .. devicename .. " -- sget " .. channel)
    local status = fd:read("*all")
    fd:close()

    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = string.format("% 3d", volume)

    status = string.match(status, "%[(o[^%]]*)%]")

    if string.find(status, "on", 1, true) then
      volume = volume .. "%"
    else
      volume = "M"
    end
    widget.text = volume
  else
    if mode == "up" then
--      io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%+"):read("*all")
      io.popen("amixer -q -D " .. devicename .. " sset " .. channel .. " 5%+"):read("*all")
    elseif mode == "down" then
--      io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-"):read("*all")
      io.popen("amixer -q -D " .. devicename .. " sset " .. channel .. " 5%-"):read("*all")
    else
--      io.popen("amixer sset Master toggle"):read("*all")
      io.popen("amixer sset Master toggle"):read("*all")
    end
    volume("update", widget)
  end
end

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers

naughty.config.presets.normal.opacity = 0.8
naughty.config.presets.low.opacity = 0.8
naughty.config.presets.critical.opacity = 0.8

-- naughty.config.defaults.font = "Verdana 8"

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}



-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


-- os.execute("kill `ps ax |grep gnome-settings-daemon$| awk '{ print $1 }'`")
-- os.execute("gnome-settings-daemon &")
-- os.execute("killall nm-applet")
-- os.execute("nm-applet &")
os.execute("autocutsel -fork &")
os.execute("autocutsel -selection PRIMARY -fork &")
