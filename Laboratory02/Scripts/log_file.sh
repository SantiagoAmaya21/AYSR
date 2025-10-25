#!/bin/bash
# This script provides a simple menu to display system log files
# It shows either the last 15 lines or lines containing a specific word

clear
while true; do
    # Main menu
    echo "Menu"
    echo "1. Display log's files last 15 lines"
    echo "2. Display log's files last 15 lines that contain a specific word"
    echo "3. Finish"
    read -p "Enter your option: " value

    case $value in
        1)	# Show the last 15 lines of each log file
            clear
            echo "log file: /var/log/messages. The last 15 lines are: "
            tail -n 15 /var/log/messages
            echo "-------------------------------------------------------"
            echo "log file: /var/log/syslog. The last 15 lines are: "
            tail -n 15 /var/log/syslog
            echo "-------------------------------------------------------"
            echo "log file: /var/log/maillog. The last 15 lines are:"
            tail -n 15 /var/log/maillog
            echo "-------------------------------------------------------"
            ;;
        2)	# Show the last 15 lines containing a given word
            clear
            read -p "Enter the word: " word

            echo "log file: /var/log/messages. With the word (\"$word\") in the last 15 lines:"
            tail -n 15 /var/log/messages | grep $word
            echo "------------------------------------------------------------------------------"

            echo "log file: /var/log/syslog. With the word (\"$word\") in the last 15 lines:"
            tail -n 15 /var/log/syslog | grep $word
            echo "------------------------------------------------------------------------------"

            echo "log file: /var/log/maillog. With the word (\"$word\") in the last 15 lines:"
            tail -n 15 /var/log/maillog | grep $word
            echo "------------------------------------------------------------------------------"
            ;;
        3)	# Exit program
            clear
            break
            ;;
        *)	# Invalid input handling
            echo "Invalid option."
            read -p "Press Enter to continue..."
            ;;
    esac
done
