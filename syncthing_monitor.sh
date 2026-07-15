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

# Get Syncthing's runtime home path
get_syncthing_home() {
    if [[ "$SERVICE_SCOPE" == "system" ]]; then
	systemctl show syncthing -p ExecStart --value 2>/dev/null \
	    | grep -o -- '--home=[^ ]*' \
	    | cut -d= -f2
    elif [[ "$SERVICE_SCOPE" == "user" ]]; then
	echo "$HOME/.local/state/syncthing"
    else
	return 1
    fi
}

SYNCTHING_HOME=$(get_syncthing_home)

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

# Gets the configured sync folders' IDs
get_sync_folder_ids() {
    syncthing cli --home="$SYNCTHING_HOME" config folders list 2>/dev/null
}

# Gets the path using the folder ID
get_sync_folder_path() {
    syncthing cli --home="$SYNCTHING_HOME" config folders "$1" path get 2>/dev/null
}

# Expands tildes in the path to $HOME
expand_path() {
    sync_folder_path="$1"

    sync_folder_path="${sync_folder_path/#\~/$HOME}"

    echo "$sync_folder_path"
}

# Gets the size of a filesystem path
get_folder_size() {
    if [[ -d "$1" ]]; then
	du -sh "$1" | cut -f1
    else
	echo "N/A"
    fi
}

# Prints sync folders and their respective sizes
print_sync_folders() {
    folder_ids=$(get_sync_folder_ids)

    # If no sync folders are configured, print "N/A" and stop
    # execution
    if [[ -z "$folder_ids" ]]; then
	echo "N/A"
	return
    fi

    for folder_id in $folder_ids; do
	folder_path=$(get_sync_folder_path "$folder_id")
	folder_path=$(expand_path "$folder_path")
	size=$(get_folder_size "$folder_path")

	printf "%-30s %s\n" "- $folder_path" "$size"
    done
}

# ===== Printing starts here =====
echo "=== Syncthing Status ==="
echo
echo "Service status: $(get_status)"
echo "Service enabled: $(get_enabled)"
echo "PID: $(get_pid_display)"
echo "Memory: $(get_memory)"
echo "CPU: $(get_cpu)"
echo
echo "Sync folders:"
print_sync_folders
