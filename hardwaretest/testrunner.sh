#!/bin/bash

set -e # exit on first error

# hardcoding paths teehee
proc_frequency="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq"

# argument checking
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <source_asm.s>"
  exit 1
fi

# name wrangling
src_file="$1"
out_file="${src_file//.s/}"

# do assembly, linking with gcc
gcc -o "$out_file" "$src_file"

for ((i=6; i<=18; i+=6)); do
  # set proc cycle limits
  set_freq=$(echo "scale=1; $i/10" | bc)
  sudo cpupower frequency-set -u "${set_freq}GHz" -d "${set_freq}GHz" 
  
  # report frequency (sanity check)
  echo "Processor frequency before running program (KHz):"
  sudo cat "$proc_frequency"

  # spawn
  ./"$out_file" &
  pid=$!
  sleep 10 # accouting for OS overhead
  echo "Take reading"
  sleep 5 # slight delay
  kill $pid # done

  echo "Processor frequency after prog run (KHz):"
  sudo cat "$proc_frequency"

done 

# reset system after computer done
sudo cpupower frequency-set -u "1.8GHz" -d "0.6GHz" 
