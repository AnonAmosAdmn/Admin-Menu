🛠️ Admin Menu Script
A powerful and interactive Bash-based administration menu for Linux systems. Designed for system admins and power users, this script automates system checks, network diagnostics, package verification, rootkit detection, and much more—all in a colorful, user-friendly menu interface.

📦 Features
Auto-Installation of required system tools

System Info (hostname, uptime, logged-in users)

Network Scan using Nmap

Disk Usage viewer

Live Bandwidth Monitoring with iftop

CPU-Heavy Process Report

Public IP Detection

Open Listening Ports (ss)

Running Systemd Services

System Update (apt update && upgrade)

Ping Test to any host

WHOIS Lookup for domains/IPs

Traceroute network paths

UFW Firewall Status

List Installed Packages

Crontab Viewer

Active SSH Sessions

Rootkit Check (via chkrootkit or rkhunter)

# 🚀 Getting Started
Prerequisites
Make sure your system is Debian/Ubuntu-based. Required tools include:

nmap

iftop

whois

traceroute

ufw

curl

chkrootkit

rkhunter

ss

ps

These tools are automatically installed at startup if missing.

#  📥 Installation

git clone https://github.com/yourusername/admin-menu-script.git

cd admin-menu-script

chmod +x admin_menu.sh

./admin_menu.sh

🧠 Usage
Just run the script and choose from the numbered options in the menu. Results are color-coded for better visibility.

Press Enter to return to the menu after each task.

🔐 Security Notes
chkrootkit or rkhunter is used to detect potential rootkits.

Uses sudo where needed (you will be prompted for your password).

Scans your local subnet for live hosts with nmap.

💡 Tips
To enable real-time network monitoring, run the script in a terminal with sufficient permissions (iftop needs root).

Use screen or tmux for persistent sessions.

You can easily expand this script by adding your own tools and functions to the menu.

📜 License
MIT License
