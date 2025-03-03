#!/usr/bin/env bash

FREQ="${FREQ:-157.95M}"  # Default to 157.95M if FREQ is not set

rtl_fm -f "$FREQ" -p 27 -s 22050 | \
multimon-ng -q -b1 -c -t raw -a POCSAG512 -a POCSAG1200 -a POCSAG2400 -a FLEX -f alpha /dev/stdin | \
node reader.js
