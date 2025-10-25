#!/bin/bash

# Script to perform file and text operations in a given directory or file.
# Provides options to search files, count word appearances, display lines,
# and show the first/last N lines of a file.
# The script displays a menu and loops until the user chooses to exit.

while true; do
    echo "Menu"
    echo "1. Display file path and number of appearances in a given directory"
    echo "2. Display a word in a file and number of times it was repeated"
    echo "3. Display the line where the word was found and number of times it was repeated per file"
    echo "4. Count the number of lines in a file"
    echo "5. Display the first n lines of a file"
    echo "6. Display the last n lines of a file"
    echo "7. Finish"
    read -p "Enter your option: " value

    case $value in
        1)  # Search for a file inside a directory and count appearances
            clear
            read -p "Enter a path: " path
            read -p "Enter a file name: " file
            # Find files matching the name (case-insensitive)
            find $path -type f -iname "*$file*"
            # Count number of matches
            amount=$(find $path -type f -iname "*$file*" | wc -l)
            echo "Number of files found: $amount"
            ;;
        2)  # Search for a word inside a file and count its occurrences
            clear
            read -p "Enter a file name: " file
            read -p "Enter a word: " word
            # Show occurrences with line number (-n) and only matches (-o)
            grep -no $word $file
            # Count occurrences
            amount=$(grep -no $word $file | wc -l)
            echo "Number of times it was repeated: $amount"
            ;;
        3)  # Search for a word across multiple files in a path
            clear
            read -p "Enter a path: " path
            read -p "Enter a file: " file
            read -p "Enter a word: " word
            # Find matching files
            files=$(find $path -iname "*$file*")
            for line in $files; do
                # Count word appearances per file
                amount=$(grep -no $word $line | wc -l)
                if [ $amount -ne 0 ]; then
                    echo "===> FILE: $line <==="
                    grep -no $word $line
                    echo "Number of times '$word' was repeated: $amount"
                fi
            done
            ;;
        4)  # Count number of lines in a file
            clear
            read -p "Enter a file path: " file
            echo "Number of lines in file $file is:"
            echo $(less $file | wc -l)
            ;;
        5)  # Display the first N lines of a file
            clear
            read -p "Enter a file path: " file
            if [ -f "$file" ]; then
                read -p "How many lines do you want to display? " n
                clear
                echo "First $n lines in file: $file"
                head -n "$n" "$file" | less
            else
                echo "The file doesn't exist."
                read -p "Press Enter to continue..."
            fi
            ;;
        6)  # Display the last N lines of a file
            clear
            read -p "Enter a file path: " file
            if [ -f "$file" ]; then
                read -p "How many lines do you want to display? " n
                clear
                echo "Last $n lines in file: $file"
                tail -n "$n" "$file" | less
            else
                echo "The file doesn't exist."
                read -p "Press Enter to continue..."
            fi
            ;;
        7)  # Exit program
            clear
            break
            ;;
        *)  # Invalid input handling
            echo "Invalid option."
            read -p "Press Enter to continue..."
            ;;
    esac
done
