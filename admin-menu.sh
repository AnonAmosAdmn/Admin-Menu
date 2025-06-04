#!/bin/bash

clear
# === Colors ===
GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
NC="\e[0m" # No Color

# === Check and Install Required Tools ===

REQUIRED_TOOLS=("nmap" "iftop" "whois" "traceroute" "ufw" "curl" "chkrootkit" "rkhunter" "ss" "ps")

clear_screen() {
    clear
    echo -e "${GREEN} ${NC}"
    echo -e "${GREEN}    ___       __                        __  ___ ${NC}"
    echo -e "${GREEN}   /   | ____/ /___ ___  (_)___        /  |/  /__  ____  __  __${NC}"
    echo -e "${GREEN}  / /| |/ __  / __ \`__ \/ / __ \______/ /|_/ / _ \/ __ \/ / / / ${NC}"
    echo -e "${GREEN} / ___ / /_/ / / / / / / / / / /_____/ /  / /  __/ / / / /_/ / ${NC}"
    echo -e "${GREEN}/_/  |_\__,_/_/ /_/ /_/_/_/ /_/     /_/  /_/\___/_/ /_/\__,_/  ${NC}"
    echo -e "${GREEN}================================================================${NC}"
    echo -e "${GREEN} ${NC}"
}


clear_screen
echo -e "${BLUE}Updating package lists...${NC}"
sudo apt-get update -y

clear_screen
echo -e "${BLUE}Checking and installing required packages...${NC}"

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo -e "${RED}Missing: $tool${NC} — Installing..."
        sudo apt-get install -y "$tool"
    else
        echo -e "${GREEN}$tool is installed.${NC}"
    fi
done

echo -e "${BLUE}All required packages are installed.${NC}"
sleep 2

# === Functions ===

system_info() {
    clear_screen
    echo -e "${BLUE}--- System Info ---${NC}"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Logged-in users:"
    who
}

network_scan() {
    clear_screen
    echo -e "${BLUE}--- Network Scan ---${NC}"
    
    # Get the first non-loopback IPv4 address
    ip_info=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | head -n1)

    if [[ -z "$ip_info" ]]; then
        echo -e "${RED}Could not determine local IP address.${NC}"
        return 1
    fi

    # Extract the subnet base (before slash)
    ip_base=${ip_info%%/*}

    # Get the first three octets of IP for /24 subnet
    subnet="${ip_base%.*}.0/24"

    echo -e "${BLUE}Scanning IP range: $subnet${NC}"

    command -v nmap >/dev/null 2>&1 || {
        echo -e "${RED}nmap is not installed.${NC}"
        return 1
    }

    nmap -sn "$subnet"
}


disk_usage() {
    clear_screen
    echo -e "${BLUE}--- Disk Usage ---${NC}"
    df -h | grep -v tmpfs
}

net_monitor() {
    clear_screen
    if ! command -v iftop >/dev/null 2>&1; then
        echo -e "${RED}iftop not installed. Try: sudo apt install iftop${NC}"
        return 1
    fi

    # Detect primary active interface (e.g., eth0, wlan0, etc.)
    iface=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
    if [[ -z "$iface" ]]; then
        echo -e "${RED}Could not detect active network interface.${NC}"
        return 1
    fi

    echo -e "${BLUE}Running iftop on interface: $iface${NC}"
    sudo iftop -i "$iface"
}


process_report() {
    clear_screen
    echo -e "${BLUE}--- Top 10 Processes by CPU ---${NC}"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 11
}

public_ip() {
    clear_screen
    echo -e "${BLUE}--- Public IP ---${NC}"
    curl -s https://api.ipify.org
}

open_ports() {
    clear_screen
    echo -e "${BLUE}--- Listening Ports ---${NC}"
    sudo ss -tuln
}

service_status() {
    clear_screen
    echo -e "${BLUE}--- Systemd Services (running) ---${NC}"
    systemctl list-units --type=service --state=running
}

update_system() {
    clear_screen
    echo -e "${BLUE}--- Updating System ---${NC}"
    sudo apt update && sudo apt upgrade -y
}

ping_test() {
    clear_screen
    read -p "Enter a host to ping: " host
    ping -c 4 "$host"
}

whois_lookup() {
    clear_screen
    read -p "Enter domain or IP: " target
    command -v whois >/dev/null 2>&1 || {
        echo -e "${RED}whois not installed. Run: sudo apt install whois${NC}"
        return
    }
    whois "$target"
}

traceroute_test() {
    clear_screen
    read -p "Enter host for traceroute: " target
    command -v traceroute >/dev/null 2>&1 || {
        echo -e "${RED}traceroute not installed. Run: sudo apt install traceroute${NC}"
        return
    }
    traceroute "$target"
}

firewall_status() {
    clear_screen
    echo -e "${BLUE}--- UFW Firewall Status ---${NC}"
    command -v ufw >/dev/null 2>&1 && sudo ufw status verbose || echo -e "${RED}ufw not installed.${NC}"
}

list_installed_packages() {
    clear_screen
    echo -e "${BLUE}--- Installed Packages ---${NC}"
    dpkg-query -W -f='${binary:Package}\n' | less
}

view_crontab() {
    clear_screen
    echo -e "${BLUE}--- User Crontab ---${NC}"
    crontab -l 2>/dev/null || echo -e "${RED}No crontab found.${NC}"
}

active_ssh() {
    clear_screen
    echo -e "${BLUE}--- Active SSH Sessions ---${NC}"
    who | grep -i "pts" || echo "No active SSH sessions."
}

rootkit_check() {
    clear_screen
    echo -e "${BLUE}--- Rootkit Check ---${NC}"
    if command -v chkrootkit >/dev/null; then
        sudo chkrootkit
    elif command -v rkhunter >/dev/null; then
        sudo rkhunter --check
    else
        echo -e "${RED}Neither chkrootkit nor rkhunter is installed.${NC}"
    fi
}

# === Menu Loop ===
while true; do
    clear_screen
    echo " 1) System Info"
    echo " 2) Network Scan"
    echo " 3) Disk Usage"
    echo " 4) Live Network Monitor"
    echo " 5) Process Report"
    echo " 6) Public IP Lookup"
    echo " 7) Open Ports"
    echo " 8) Running Services"
    echo "9) Update System"
    echo "10) Ping Test"
    echo "11) WHOIS Lookup"
    echo "12) Traceroute"
    echo "13) Firewall Status"
    echo "14) List Installed Packages"
    echo "15) View Crontab"
    echo "16) Active SSH Sessions"
    echo "17) Rootkit Check"
    echo "18) Exit"
    echo "================================="
    read -p "Choose an option [1-18]: " choice

    case $choice in
        1) system_info ;;
        2) network_scan ;;
        3) disk_usage ;;
        4) net_monitor ;;
        5) process_report ;;
        6) public_ip ;;
        7) open_ports ;;
        8) service_status ;;
        9) update_system ;;
        10) ping_test ;;
        11) whois_lookup ;;
        12) traceroute_test ;;
        13) firewall_status ;;
        14) list_installed_packages ;;
        15) view_crontab ;;
        16) active_ssh ;;
        17) rootkit_check ;;
        18)
            echo -e "${RED}Goodbye!${NC}"
            exit 0
            ;;
        *) echo -e "${RED}Invalid option. Try again.${NC}" ;;
    esac

    echo
    read -p "Press Enter to continue..."
done
