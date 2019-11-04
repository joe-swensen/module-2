#!/bin/bash
export PATH=/usr/local/bin:$PATH
export DISPLAY=:0.0
sleep 10  #can be lower (5) for rpi3
sclang ~/Code/PiSynth.scd
