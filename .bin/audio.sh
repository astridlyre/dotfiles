#!/bin/bash

pactl load-module module-null-sink media.class=Audio/Sink sink_name=Simultaneous channel_map=stereo
pw-link Simultaneous:monitor_FL bluez_output.00_19_5C_85_9C_CD.1:playback_FL
pw-link Simultaneous:monitor_FR bluez_output.00_19_5C_85_9C_CD.1:playback_FR
pw-link Simultaneous:monitor_FL bluez_output.88_C9_E8_40_BC_F6.1:playback_FL
pw-link Simultaneous:monitor_FR bluez_output.88_C9_E8_40_BC_F6.1:playback_FR
