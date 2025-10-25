#!/bin/sh
# POSIX script to schedule periodic tasks in cron
# Use: ./scheduleTask.sh <Frequency> <Command>

if [ $# -ne 2 ]; then
	echo "Use: $0 \"<frequency>\" \"<Command>\""
	echo "Example: $0 \"hourly\" \"/path/to/script.sh\""
fi

case "$1" in
	"hourly")
		FREQ="0 * * * *";;
	"daily")
		FREQ="0 0 * * *";;
	"weekly")
		FREQ="0 0 * * 0";;
	"monthly")
		FREQ="0 0 1 * *";;
	*)
		FREQ="$1";;
esac

TEMP_CRON="/tmp/crontab_$$"
crontab -l > "$TEMP_CRON" 2>/dev/null || touch "$TEMP_CRON"
echo "$FREQ $2" >> "$TEMP_CRON"

if crontab "$TEMP_CRON"; then
	echo "Task scheduled: $FREQ $2"
	rm -f "$TEMP_CRON"
else
	echo "Error adding task to crontab"
	rm -f "$TEMP_CRON"
	exit 1
fi