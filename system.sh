#!/bin/bash

# Terminal Colors
RESET='\033[0m'
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'

# Function to print headers
print_header() {
    echo -e "${CYAN}======================================"
    echo -e "        $1"
    echo -e "======================================${RESET}"
}

# Function to gather system information
get_system_info() {
    vcpus=$(nproc)
    total_ram=$(free -h | grep Mem | awk '{print $2}')
    used_ram=$(free -h | grep Mem | awk '{print $3}')
    available_ram=$(free -h | grep Mem | awk '{print $7}')
    total_ssd=$(df -h / | awk 'NR==2 {print $2}')
    used_ssd=$(df -h / | awk 'NR==2 {print $3}')
    available_ssd=$(df -h / | awk 'NR==2 {print $4}')
    swap_used=$(free -m | grep Swap | awk '{print $3 " MB used / " $2 " MB total"}')
    load_avg=$(uptime | awk -F'load average: ' '{print $2}')
    network_usage=$(ifstat -i eth0 1 1 | tail -n 1 | awk '{print "TX: "$1" KB/s, RX: "$2" KB/s"}')
    active_connections=$(netstat -tuln | grep -v "Proto" | wc -l)
    os_info=$(lsb_release -d | awk -F'\t' '{print $2}')
    arch_info=$(uname -m)
    kernel_version=$(uname -r)

    # Check CPU temperature (if 'sensors' is available)
    if command -v sensors &> /dev/null
    then
        cpu_temp=$(sensors | grep 'Core 0' | awk '{print $3}' | sed 's/+//g')
    else
        cpu_temp="N/A"
    fi

    # Check GPU status (if nvidia-smi is available)
    if command -v nvidia-smi &> /dev/null
    then
        gpu_info=$(nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits)
    else
        gpu_info="No NVIDIA GPU detected."
    fi
}

# Function to display system information
display_system_info() {
    print_header "System Information"

    echo -e "${BOLD}${WHITE}vCPU Cores:${RESET} ${GREEN}$vcpus${RESET}"
    echo -e "${BOLD}${WHITE}Total RAM:${RESET} ${GREEN}$total_ram${RESET}"
    echo -e "${BOLD}${WHITE}Used RAM:${RESET} ${YELLOW}$used_ram${RESET}"
    echo -e "${BOLD}${WHITE}Available RAM:${RESET} ${GREEN}$available_ram${RESET}"
    echo -e "${BOLD}${WHITE}Total SSD Space:${RESET} ${GREEN}$total_ssd${RESET}"
    echo -e "${BOLD}${WHITE}Used SSD Space:${RESET} ${YELLOW}$used_ssd${RESET}"
    echo -e "${BOLD}${WHITE}Available SSD Space:${RESET} ${GREEN}$available_ssd${RESET}"
    echo -e "${BOLD}${WHITE}Swap Usage:${RESET} ${YELLOW}$swap_used${RESET}"
    echo -e "${BOLD}${WHITE}CPU Temperature:${RESET} ${RED}$cpu_temp${RESET}"
    echo -e "${BOLD}${WHITE}Load Average:${RESET} ${GREEN}$load_avg${RESET}"
    echo -e "${BOLD}${WHITE}Network Usage:${RESET} ${GREEN}$network_usage${RESET}"
    echo -e "${BOLD}${WHITE}Active Connections:${RESET} ${GREEN}$active_connections${RESET}"
    echo -e "${BOLD}${WHITE}OS Info:${RESET} ${GREEN}$os_info${RESET}"
    echo -e "${BOLD}${WHITE}Architecture:${RESET} ${GREEN}$arch_info${RESET}"
    echo -e "${BOLD}${WHITE}Kernel Version:${RESET} ${GREEN}$kernel_version${RESET}"

    # GPU Information
    print_header "GPU Information"
    if [[ "$gpu_info" == "No NVIDIA GPU detected." ]]; then
        echo -e "${RED}$gpu_info${RESET}"
    else
        echo -e "${GREEN}$gpu_info${RESET}" | awk -F, '{ printf "GPU: %s | Usage: %s%% | Temp: %s°C | Memory: %sMB / %sMB\n", $1, $2, $3, $4, $5 }'
    fi

    echo -e "${CYAN}======================================${RESET}"
}

# Function to monitor top CPU processes
monitor_cpu_processes() {
    print_header "Top 5 CPU Processes"
    ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -6
}

# Function to monitor CPU usage
monitor_cpu_usage() {
    print_header "CPU Usage"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

# Function to monitor memory usage
monitor_memory_usage() {
    print_header "Memory Usage"
    free -m | grep Mem | awk '{print $3 " MB used / " $2 " MB total"}'
}

# Function to monitor disk usage
monitor_disk_usage() {
    print_header "Disk Usage"
    df -h | grep '/dev/' | awk '{print $5 " used on " $1}'
}

# Function to monitor active screen sessions
monitor_screens() {
    print_header "Active Screen Sessions"
    screen -ls
}

# Function to show a loading animation
show_loading() {
    echo -n "Loading system information"
    for i in {1..3}
    do
        echo -n "."
        sleep 1
    done
    echo ""
}

# Main monitoring loop
while true; do
    # Show loading animation
    show_loading

    # Get system information
    get_system_info

    # Clear screen
    tput reset

    # Display system information
    display_system_info

    # Display monitoring information
    monitor_cpu_processes
    monitor_cpu_usage
    monitor_memory_usage
    monitor_disk_usage
    monitor_screens

    # Wait 60 seconds before updating again
    sleep 60
done
