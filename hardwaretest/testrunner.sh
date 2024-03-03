#!/bin/bash

# hardcoding paths teehee
proc_frequency="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq"

if [ "$#" -ne 1]; then
  echo "Usage: $0 <source_asm.s>"
  exit 1
fi

src_file="$1"
out_file="${src_file//.s/}"

# do assembly, linking with gcc
gcc -o "$out_file" "$src_file"

echo "Processor frequency before running program (KHz):"
sudo cat "$proc_frequency"

./"$out_file" &

pid=$!

sleep 120

kill $pid

echo "Processor frequency after two minutes of running (KHz):"
sudo cat "$proc_frequency"

