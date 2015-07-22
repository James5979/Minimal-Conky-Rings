# About
A minimalist approach to [Conky Lua Rings][0].

Example:

![Settings](https://github.com/James5979/Minimal-Conky-Rings/blob/master/Conky%20Rings.png)

# Installation

Move the hidden .conkyrc file to your home folder, and the hidden
.conky directory to the same location. Make sure that you have Lm
sensors installed and configured.

In Debian:

        sudo apt-get install lm-sensors
        sudo sensors-detect

You may wish to read the comments in the script rings.lua, as you
may need to make some small adjustments to the file. For example:
you may need to change the wireless interface to whatever interface
your wireless uses.

Now you can launch Conky normally by typing 'conky &' into your
terminal window.

Due to the rings.lua script, if you need to restart Conky, it should
be done the following way:

        killall conky; conky &

You may need to give permissions to Conky in order for the 'WIFI'
meter to work. On Debian, (or possibly other distros), this can be
done by executing the following command:

        sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/conky

[0]: http://gnome-look.org/content/show.php/Conky+lua?content=139024
