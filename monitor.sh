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

# Gets current disk usage using df
get_disk_usage() {
    disk_usage=$(df --output=pcent / | sed -n 2p | tr -d '% ')

    echo "$disk_usage"
}

# Calculates current system uptime from /proc/uptime
get_uptime() {
    # Get total seconds of uptime
    uptime_seconds=$(awk '{printf "%.0f\n", $1}' /proc/uptime)

    # Calculate uptime in days
    uptime_days=$(( uptime_seconds / 86400 ))

    # Get remaining seconds after calculating amount of days
    remaining_seconds_after_days=$(( uptime_seconds % 86400 ))

    # Calculate remaining uptime in hours
    uptime_hours=$(( remaining_seconds_after_days / 3600 ))

    # Get remaining seconds after calculating amount of hours
    remaining_seconds_after_hours=$(( remaining_seconds_after_days % 3600 ))

    # Calculate remaining uptime in minutes
    uptime_minutes=$(( remaining_seconds_after_hours / 60 ))

    if [[ $uptime_hours -eq 0 && $uptime_minutes -eq 0 ]]; then
	echo "$uptime_seconds seconds"
    elif [[ $uptime_days -eq 0 && $uptime_hours -eq 0 ]]; then
	echo "$uptime_minutes minutes"
    elif [[ $uptime_days -eq 0 ]]; then
	echo "$uptime_hours hours $uptime_minutes minutes"
    else
	echo "$uptime_days days $uptime_hours hours $uptime_minutes minutes"
    fi
}

get_top_memory_process() {
    # Get all processes' memory usage and command name with ps, sort by memory usage
    # Then, get the process with most memory usage with sed
    # Lastly, format the output with awk
    ps -eo comm,pmem --sort=-pmem | sed -n 2p | awk '{print $1 " (" $2 "%)"}'
}

# ===== System statistics printing starts here =====
echo "=== System Health Report ==="
echo

# Output machine's hostname
echo "Hostname: $(hostname)"

# Output date and time
echo "Date: $(date +%F\ %T)"
echo

# Output system usage
echo "CPU Usage: $(get_cpu_usage)%"
echo "Memory Usage: $(get_memory_usage)%"
echo "Disk usage: $(get_disk_usage)%"
echo "Uptime: $(get_uptime)"
echo
echo "Top memory process: $(get_top_memory_process)"
