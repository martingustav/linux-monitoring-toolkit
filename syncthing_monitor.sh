#!/bin/bash

# Get Syncthing's service scope (system or user)
get_service_scope() {
    if [[ $(systemctl show syncthing -P LoadState) == "loaded" ]]; then
	echo "system"
    elif [[ $(systemctl --user show syncthing -P LoadState) == "loaded" ]]; then
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

# Get the Syncthing service's PID
get_pid() {
    run_systemctl show syncthing -P MainPID
}

# Get Syncthing's service status
get_status() {
    run_systemctl is-active syncthing
}

# Check whether the Syncthing service is enabled
get_enabled() {
    run_systemctl is-enabled syncthing
}

# Get Syncthing's memory usage
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
echo "Service status: $(get_status)"
echo "Service enabled: $(get_enabled)"
echo "PID: $(get_pid)"
echo "Memory: $(get_memory)%"
echo "CPU: $(get_cpu)%"
#echo "Sync folder size: $(get_folder_size)"
