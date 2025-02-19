#!/usr/bin/env bash

rtl_fm -f 157.95M -p 27 -s 22050 | \
multimon-ng -q -b1 -c -t raw -a POCSAG512 -a POCSAG1200 -a POCSAG2400 -a FLEX -f alpha /dev/stdin | \
node reader.js

#exec tail -f /dev/null
