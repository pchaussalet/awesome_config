 binaryclock = {}
 binaryclock.widget = widget({type = "imagebox"})
 binaryclock.w = 51 --width 
 binaryclock.h = 24 --height (better to be a multiple of 6) 
 --dont forget that awesome resizes our image with clocks to fit wibox's height
 binaryclock.show_sec = true --must we show seconds? 
 binaryclock.color_active = beautiful.bg_focus --active dot color
 binaryclock.color_bg = beautiful.bg_normal --background color
 binaryclock.color_inactive = beautiful.fg_focus --inactive dot color
 binaryclock.dotsize = math.floor(binaryclock.h / 6) --dot size
 binaryclock.step = math.floor(binaryclock.dotsize / 2) --whitespace between dots
 binaryclock.widget.image = image.argb32(binaryclock.w, binaryclock.h, nil) --create image
 if (binaryclock.show_sec) then binaryclock.timeout = 1 else binaryclock.timeout = 20 end --we don't need to update often
 binaryclock.DEC_BIN = function(IN) --thanx to Lostgallifreyan (http://lua-users.org/lists/lua-l/2004-09/msg00054.html)
     local B,K,OUT,I,D=2,"01","",0
     while IN>0 do
         I=I+1
         IN,D=math.floor(IN/B),math.mod(IN,B)+1
         OUT=string.sub(K,D,D)..OUT
     end
     return OUT
 end
 binaryclock.paintdot = function(val,shift,limit) --paint number as dots with shift from left side
       local binval = binaryclock.DEC_BIN(val)
       local l = string.len(binval)
       local height = 0 --height adjustment, if you need to lift dots up
       if (l < limit) then
              for i=1,limit - l do binval = "0" .. binval end
       end
       for i=0,limit-1 do
              if (string.sub(binval,limit-i,limit-i) == "1") then
                    binaryclock.widget.image:draw_rectangle(shift,  binaryclock.h - binaryclock.dotsize - height, binaryclock.dotsize, binaryclock.dotsize, true, binaryclock.color_active)
              else
                    binaryclock.widget.image:draw_rectangle(shift,  binaryclock.h - binaryclock.dotsize - height, binaryclock.dotsize,binaryclock.dotsize, true, binaryclock.color_inactive)
              end
              height = height + binaryclock.dotsize + binaryclock.step
        end
 end
 binaryclock.drawclock = function () --get time and send digits to paintdot()
       binaryclock.widget.image:draw_rectangle(0, 0, binaryclock.w, binaryclock.h, true, binaryclock.color_bg) --fill background
       local t = os.date("*t")
       local hour = t.hour
       if (string.len(hour) == 1) then
              hour = "0" .. t.hour
       end
       local min = t.min
       if (string.len(min) == 1) then
              min = "0" .. t.min
       end
       local sec = t.sec
       if (string.len(sec) == 1) then
              sec = "0" .. t.sec
       end
       local col_count = 6
       if (not binaryclock.show_sec) then col_count = 4 end
       local step = math.floor((binaryclock.w - col_count * binaryclock.dotsize) / 8) --calc horizontal whitespace between cols
       binaryclock.paintdot(0 + string.sub(hour, 1, 1), step, 2)
       binaryclock.paintdot(0 + string.sub(hour, 2, 2), binaryclock.dotsize + 2 * step, 4)
       binaryclock.paintdot(0 + string.sub(min, 1, 1),binaryclock.dotsize * 2 + 4 * step, 3)
       binaryclock.paintdot(0 + string.sub(min, 2, 2),binaryclock.dotsize * 3 + 5 * step, 4)
       if (binaryclock.show_sec) then
              binaryclock.paintdot(0 + string.sub(sec, 1, 1), binaryclock.dotsize * 4 + 7 * step, 3)
              binaryclock.paintdot(0 + string.sub(sec, 2, 2), binaryclock.dotsize * 5 + 8 * step, 4)
       end
       binaryclock.widget.image = binaryclock.widget.image
   end

