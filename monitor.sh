#!/bin/bash

# Takes two snapshots of /proc/stat to get current CPU usage
get_cpu_usage() {
    # Get first snapshot of all CPU usage values
    read -r _ user1 nice1 system1 idle1 iowait1 irq1 softirq1 steal1 _ < /proc/stat

    # Total CPU usage
    total1=$((user1 + nice1 + system1 + idle1 + iowait1 + irq1 + softirq1 + steal1))

    # Idle time
    idle_total1=$((idle1 + iowait1))

    sleep 1

    # Get second snapshot
    read -r _ user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 _ < /proc/stat

    total2=$((user2 + nice2 + system2 + idle2 + iowait2 + irq2 + softirq2 + steal2))
    idle_total2=$((idle2 + iowait2))

    # Calculate the total CPU usage difference
    total_delta=$((total2 - total1))

    # Calculate the idle time difference
    idle_delta=$((idle_total2 - idle_total1))

    # Calculate the final CPU usage with one decimal place
    cpu_usage=$(awk -v idle="$idle_delta" -v total="$total_delta" \
		    'BEGIN { printf "%.1f", (total - idle) * 100 / total }')

    echo "${cpu_usage}"
}

# Calculates current memory usage from /proc/meminfo
get_memory_usage() {
    available_memory=$(awk '/MemAvailable/ { print $2 }' /proc/meminfo)
    total_memory=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)

    mem_usage=$(awk -v available="$available_memory" -v total="$total_memory" \
		    'BEGIN { printf "%.1f", ((total - available) / total) * 100 }')

    echo "${mem_usage}"
}

echo -e "=== System Health Report ===\n"

# Output machine's hostname
echo "Hostname: $(hostname)"

# Output date and time
echo -e "Date: $(date +%F\ %T)\n"

# Output system usage
echo "CPU Usage: $(get_cpu_usage)%"
echo "Memory Usage: $(get_memory_usage)%"
# get_disk_usage()
# get_uptime()
# get_top_memory_process()
