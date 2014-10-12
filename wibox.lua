tags = {}
mywibox = ()

layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.floating,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier
}

mytextclock = awful.widget.textclock({ align = "right" })

for s = 1, screen.count() do
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[2])
  mywibox[s] = awful.wibox({ position = "top", screen = s })

  mywibox[s].widgets = {
    mytextclock
  }

end
