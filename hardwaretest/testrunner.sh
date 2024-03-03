#!/bin/bash

# hardcoding paths teehee
proc_frequency="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq"

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <source_asm.s>"
  exit 1
fi

src_file="$1"
out_file="${src_file//.s/}"

# do assembly, linking with gcc
gcc -o "$out_file" "$src_file"

for ((i=6; i<=18; i+=6)); do
  set_freq=$(echo "scale=1; $i/10" | bc)
  sudo cpupower frequency-set -u "${set_freq}GHz" -d "${set_freq}GHz" 
  echo "Processor frequency before running program (KHz):"
  sudo cat "$proc_frequency"

  # spawn and sleep for 1 minute with offset
  ./"$out_file" &
  pid=$!
  sleep 70
  kill $pid

  echo "Processor frequency after two minutes of running (KHz):"
  sudo cat "$proc_frequency"

done 
# reset system after computer done
sudo cpupower frequency-set -u "1.8GHz" -d "0.6GHz" 
