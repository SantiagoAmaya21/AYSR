#!/bin/sh
# POSIX Shell Script - Compatible with Slackware and Solaris
# Displays network information based on the detected operating system

# Detect operating system
OS=$(uname -s)

# Show formatted header
show_header() {
    echo "=============================================="
    echo "        Network Information Utility"
    echo "=============================================="
}

# Option 1: Show network interfaces
show_interfaces() {
    echo "---- Network Interfaces ----"
    case "$OS" in
        Linux)
            ip addr show 2>/dev/null || ifconfig -a
            ;;
        SunOS)
            ifconfig -a
            ;;
        *)
            echo "Unsupported system: $OS"
            ;;
    esac
}

# Option 2: Show routing table
show_routes() {
    echo "---- Routing Table ----"
    case "$OS" in
        Linux)
            route -n || ip route show
            ;;
        SunOS)
            netstat -r
            ;;
    esac
}

# Option 3: Show active connections
show_connections() {
    echo "---- Active Network Connections ----"
    case "$OS" in
        Linux|SunOS)
            netstat -tunap 2>/dev/null || netstat -an
            ;;
    esac
}

# Option 4: Show network statistics
show_statistics() {
    echo "---- Network Statistics ----"
    case "$OS" in
        Linux|SunOS)
            netstat -s
            ;;
    esac
}

# Option 5: Display specific interface information
show_interface_detail() {
    echo "Enter the interface name (ej. eth0, e1000g0):"
    read IFACE
    echo "---- Details for $IFACE ----"
    case "$OS" in
        Linux)
            ethtool "$IFACE" 2>/dev/null || ip -s link show "$IFACE"
            ;;
        SunOS)
            ifconfig "$IFACE"
            ;;
    esac
}

# Main menu loop
while true; do
    show_header
    echo "1) Show network interfaces"
    echo "2) Show route table"
    echo "3) Show active connections"
    echo "4) Show network statistics"
    echo "5) Display interface information"
    echo "0) Exit"
    echo "Select an option: "
    read opt
    case "$opt" in
        1) show_interfaces ;;
        2) show_routes ;;
        3) show_connections ;;
        4) show_statistics ;;
        5) show_interface_detail ;;
        0) echo "Going out..."; exit 0 ;;
        *) echo "Invalid option." ;;
    esac
    echo "\n Press Enter to continue..."
    read dummy
done
