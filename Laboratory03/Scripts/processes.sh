#!/bin/sh

# POSIX process manager script

show_processes() {
    printf "\n============= ACTIVE PROCESSES ==============\n"
    printf "%-18s %8s %8s %8s\n" "PROCESS" "PID" "MEM%%" "CPU%%"
    printf "%.50s\n" "============================================="
    if ps -eo comm,pid,pmem,pcpu 2>/dev/null | head -20 >/dev/null 2>&1; then
        ps -eo comm,pid,pmem,pcpu 2>/dev/null | head -20 | tail -n +2 | while read proc pid mem cpu; do
            printf "%-18s %8s %8s %8s\n" "$proc" "$pid" "$mem" "$cpu"
        done
    else
        ps -e | head -20 | tail -n +2
    fi
    printf "\nPress ENTER..."
    read x
}

search_process() {
    printf "\nProcess name: "
    read name
    [ -z "$name" ] && { printf "Name required.\n"; return; }
    printf "\n=== SEARCH RESULTS ===\n"
    ps -eo pid,comm,pcpu,pmem,args | grep -i "$name" | grep -v grep
    printf "\nPress ENTER..."
    read x
}

kill_process() {
    printf "\nPID to kill: "
    read pid
    case "$pid" in ''|*[!0-9]*) printf "Invalid PID.\n"; return;; esac
    kill -0 "$pid" 2>/dev/null || { printf "Process does not exist.\n"; return; }
    ps -p "$pid" 2>/dev/null
    printf "Kill process? (y/N): "
    read confirm
    case "$confirm" in [yY]*) 
        kill "$pid" 2>/dev/null && printf "Terminated.\n" || kill -9 "$pid" 2>/dev/null
    ;; esac
    printf "\nPress ENTER..."
    read x
}

restart_process() {
    printf "\nPID to restart: "
    read pid
    case "$pid" in ''|*[!0-9]*) printf "Invalid PID.\n"; return;; esac
    kill -0 "$pid" 2>/dev/null || { printf "Process does not exist.\n"; return; }
    cmd=$(ps -p "$pid" -o args= 2>/dev/null)
    printf "Command: %s\nRestart automatically? (y/N): " "$cmd"
    read confirm
    case "$confirm" in [yY]*) 
        printf "Terminating process...\n"
        kill "$pid" 2>/dev/null
        sleep 2
        printf "Restarting process...\n"
        eval "$cmd" &
        printf "Process restarted with new PID: $!\n"
    ;; esac
    printf "\nPress ENTER..."
    read x
}

while true; do
    clear 2>/dev/null || printf "\033[2J\033[H"
    printf "=== PROCESS MANAGER ===\n"
    printf "1. Show processes\n2. Search process\n3. Kill process\n"
    printf "4. Restart process\n5. Exit\nOption: "
    read opt
    case "$opt" in
        1) show_processes ;;
        2) search_process ;;
        3) kill_process ;;
        4) restart_process ;;
        5) printf "Leaving...\n"; exit 0 ;;
        *) printf "Invalid option.\n"; sleep 1 ;;
    esac
done