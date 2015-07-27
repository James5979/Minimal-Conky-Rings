--[[

Clock Rings by Linux Mint (2011), edited by despot77 (2011) and James5979 (2015).

This script draws percentage meters as rings. It is fully customisable; all options are described in the script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 146 uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num>5 in that if statement (the default). If you are only updating Conky every 2s then you should change it to update_num>3; conversely if you update Conky every 0.5s, you should use update_num>10. Also, if you change your Conky, it is best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save the script to ~/.conky/rings.lua):
    lua_load ~/.conky/rings.lua
    lua_draw_hook_pre rings

]]

settings_table = {
    {
        name='cpu',
        arg='cpu0',
        max=100,
        bg_colour=0xffffff,
        bg_alpha=0.2,
        fg_colour=0xc1c1c1,
        fg_alpha=0.8,
        x=40, y=30,
        radius=20,
        thickness=5,
        start_angle=-90,
        end_angle=180
    },
    {
        name='memperc',
        arg='',
        max=100,
        bg_colour=0xffffff,
        bg_alpha=0.2,
        fg_colour=0xc1c1c1,
        fg_alpha=0.8,
        x=100, y=30,
        radius=20,
        thickness=5,
        start_angle=-90,
        end_angle=180
    },
-- You must have Lm sensors installed (and configured), for the temperature ring to work
    {
        name='exec',
        arg='sensors | grep "Core 0:" | cut -d+ -f2 | cut -c1-2',
        max=100,
        bg_colour=0xffffff,
        bg_alpha=0.2,
        fg_colour=0xc1c1c1,
        fg_alpha=0.8,
        x=160, y=30,
        radius=20,
        thickness=5,
        start_angle=-90,
        end_angle=180
    },
    {
        name='battery_percent',
        arg='BAT0',
        max=100,
        bg_colour=0xffffff,
        bg_alpha=0.2,
        fg_colour=0xc1c1c1,
        fg_alpha=0.8,
        x=220, y=30,
        radius=20,
        thickness=5,
        start_angle=-90,
        end_angle=180
    },
-- Change the wireless interface below to whatever interface your wireless uses, i.e. wlan0, eth1, ath0, etc
    {
        name='wireless_link_qual_perc',
        arg='wlan0',
        max=100,
        bg_colour=0xffffff,
        bg_alpha=0.2,
        fg_colour=0xc1c1c1,
        fg_alpha=0.8,
        x=280, y=30,
        radius=20,
        thickness=5,
        start_angle=-90,
        end_angle=180
    },
}

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
    local w,h=conky_window.width,conky_window.height

    local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

    local angle_0=sa*(2*math.pi/360)-math.pi/2
    local angle_f=ea*(2*math.pi/360)-math.pi/2
    local t_arc=t*(angle_f-angle_0)

-- Draw background ring

    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    cairo_set_line_width(cr,ring_w)
    cairo_stroke(cr)
    
-- Draw indicator ring

    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
    cairo_stroke(cr)
end

function conky_rings()
    local function setup_rings(cr,pt)
    local str=''
    local value=0

    str=string.format('${%s %s}',pt['name'],pt['arg'])
    str=conky_parse(str)

    value=tonumber(str)
    if not value then
        value=0
    end
    pct=value/pt['max']

    draw_ring(cr,pct,pt)
end

-- Check that Conky has been running for at least 5s

if conky_window==nil then return end
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

    local cr=cairo_create(cs)

    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)

    if update_num>5 then
        for i in pairs(settings_table) do
            setup_rings(cr,settings_table[i])
        end
    end
end
