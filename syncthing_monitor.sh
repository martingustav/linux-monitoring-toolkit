#!/bin/bash

get_pid() {
    systemctl show syncthing -P MainPID
}

# Gets Syncthing's memory usage
get_memory() {
    ps -p $(get_pid) -o pmem= | awk '{printf "%.1f\n", $1}'
}

# Get Syncthing's cpu usage
get_cpu() {
    ps -p $(get_pid) -o pcpu= | awk '{printf "%.1f\n", $1}'
}

# ===== Printing starts here =====
echo "=== Syncthing Status ==="
echo
echo "Service status: $(systemctl is-active syncthing)"
echo "Service enabled: $(systemctl is-enabled syncthing)"
echo "PID: $(get_pid)"
echo "Memory: $(get_memory)%"
echo "CPU: $(get_cpu)%"
#echo "Sync folder size: $(get_folder_size)"
