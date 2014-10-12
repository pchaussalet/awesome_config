terminal = "urxvt"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

sndcard = "alsa_output.pci-0000_00_1b.0.analog-stereo"
