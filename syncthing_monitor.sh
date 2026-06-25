#!/bin/bash

# Get Syncthing's service scope (system or user)
get_service_scope() {
    if [[ $(systemctl show syncthing -P LoadState 2> /dev/null) == "loaded" ]]; then
	echo "system"
    elif [[ $(systemctl --user show syncthing -P LoadState 2> /dev/null) == "loaded" ]]; then
	echo "user"
    else
	echo "none"
    fi
}

SERVICE_SCOPE=$(get_service_scope)

# Helper function which runs systemctl with the correct service scope
run_systemctl() {
    if [[ $SERVICE_SCOPE == "system" ]]; then
	systemctl "$@"
    elif [[ $SERVICE_SCOPE == "user" ]]; then
	systemctl --user "$@"
    else
	return 1 # Failure code
    fi
}

# Get the Syncthing service's PID for internal script use
PID=$(run_systemctl show syncthing -P MainPID)

# Get the Syncthing service's PID for use as display value
get_pid_display() {
    if [[ "$PID" != "" && "$PID" -ne 0 ]]; then
	echo "$PID"
    else
	echo "N/A"
    fi
}

# Get Syncthing's service status
get_status() {
    if service_status=$(run_systemctl is-active syncthing); then
	echo "$service_status"
    else
	echo "N/A"
    fi
}

# Check whether the Syncthing service is enabled
get_enabled() {
    if service_enabled=$(run_systemctl is-enabled syncthing); then
	echo "$service_enabled"
    else
	echo "N/A"
    fi
}

# Get Syncthing's memory usage
get_memory() {
    if [[ "$PID" != "" &&  "$PID" -ne 0 ]]; then
	ps -p "$PID" -o pmem= | awk '{printf "%.1f%%\n", $1}'
    else
	echo "N/A"
    fi
}

# Get Syncthing's CPU usage
get_cpu() {
    if [[ "$PID" != "" && "$PID" -ne 0 ]]; then
	ps -p "$PID" -o pcpu= | awk '{printf "%.1f%%\n", $1}'
    else
	echo "N/A"
    fi
}

# ===== Printing starts here =====
echo "=== Syncthing Status ==="
echo
echo "Service status: $(get_status)"
echo "Service enabled: $(get_enabled)"
#echo "Sync folder size: $(get_folder_size)"
echo "PID: $(get_pid_display)"
echo "Memory: $(get_memory)"
echo "CPU: $(get_cpu)"
