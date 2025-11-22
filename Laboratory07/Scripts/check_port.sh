#!/bin/sh
# POSIX Script - Checks if a port is open and what service is running on it

OS=$(uname -s)

echo "Enter the port number to check:"
read PORT

echo "Verifying port $PORT in $OS..."

case "$OS" in
    Linux)
        # Check if the port is in use
        netstat -tuln | awk -v p=":$PORT" '$4 ~ p' > /tmp/portcheck.$$
        ;;
    SunOS)
        netstat -an | grep ".$PORT" > /tmp/portcheck.$$
        ;;
    *)
        echo "Unsupported system: $OS"
        exit 1
        ;;
esac

if [ -s /tmp/portcheck.$$ ]; then
    echo "The port $PORT It's OPEN."
    # Try to detect service
    SERVICE=$(grep ".$PORT" /etc/services 2>/dev/null | awk '{print $1}' | head -n1)
    if [ -n "$SERVICE" ]; then
        echo "Associated service: $SERVICE"
    else
        echo "No associated service was found in /etc/services."
    fi
else
    echo "The port $PORT its CLOSED or was not found in use."
fi

rm -f /tmp/portcheck.$$
