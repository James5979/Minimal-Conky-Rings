# About
A minimalist approach to [Conky Lua Rings][0].

Example:

![Settings](https://github.com/James5979/Minimal-Conky-Rings/blob/master/Conky%20Rings.png)

# Installation

Move the hidden .conkyrc file to the usual location in your home
folder, and the hidden .conky directory to the same location. Now
launch Conky normally by typing 'conky &' into your terminal.

Due to the rings.lua script, if you need to restart Conky, it should
be done in the following way:

        killall conky; conky &

You may need to give permissions to Conky in order for the 'WIFI'
meter to work. On Debian, (or possibly other distros), this can be
done by executing the following command:

        sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/conky

[0]: http://gnome-look.org/content/show.php/Conky+lua?content=139024
