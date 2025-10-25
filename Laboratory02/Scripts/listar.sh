#!/bin/bash

# Script to list and filter files in a given directory (including hidden ones).
# Provides options to sort files (by date, size, type) and filter them (starts/ends/contains with string).
# Supports recursive search into subdirectories when filtering.

# A path must be delivered as the first argument, for example: ./script.sh /etc
path=$1

# Main loop: keep showing the menu until the user chooses "Finish"
while true; do
    echo "Menu"
    echo "1. Sort by feature"
    echo "2. Sort by conditions"
    echo "3. Finish"
    read -p "Enter an option: " value

    case $value in
        1)  # Sorting menu
            echo "1. Sort files by most recent"
            echo "2. Sort files by Oldest"
            echo "3. Sort files from largest to smallest size"
            echo "4. Sort files from smallest to largest size"
            echo "5. Sort files by file type"
            read -p "Enter an option: " submenu
            case $submenu in
                1)  # Most recent
                    clear
                    ls -lA --sort=time $path | less
                    files=$(ls -A --sort=time $path)
                    file=$(ls -A --sort=time $path | head -n 2 | tail -n 1)
                    pastDate=$(stat -c%y $path'/'$file | awk '{ print $1 }')
                    count=1
                    for file in $files; do
                        newDate=$(stat -c%y $path'/'$file | awk '{ print $1 }')
                        if [ "$pastDate" = "$newDate" ]; then
                            count=$((count + 1))
                        else
                            echo "The number of files with the date $pastDate is $count"
                            count=1
                            pastDate=$newDate
                        fi
                    done
                ;;
                2)  # Oldest
                    clear
                    ls -lrA --sort=time $path | less
                    files=$(ls -rA --sort=time $path)
                    file=$(ls -rA --sort=time $path | head -n 2 | tail -n 1)
                    pastDate=$(stat -c%y $path'/'$file | awk '{ print $1 }')
                    count=1
                    for file in $files; do
                        newDate=$(stat -c%y $path'/'$file | awk '{ print $1 }')
                        if [ "$pastDate" = "$newDate" ]; then
                            count=$((count + 1))
                        else
                            echo "The number of files with the date $pastDate is $count"
                            count=1
                            pastDate=$newDate
                        fi
                    done
                ;;
                3)  # Size: largest to smallest
                    clear
                    ls -SlA $path | less
                    files=$(ls -SA $path)
                    file=$(ls -SA $path | head -n 2 | tail -n 1)
                    pastSize=$(stat -c%s $path'/'$file)
                    count=1
                    for file in $files; do
                        newSize=$(stat -c%s $path'/'$file)
                        if [ $pastSize -eq $newSize ]; then
                            count=$((count + 1))
                        else
                            echo "The number of files with the size $pastSize is $count"
                            count=1
                            pastSize=$newSize
                        fi
                    done
                ;;
                4)  # Size: smallest to largest
                    clear
                    ls -SlrA $path | less
                    files=$(ls -SrA $path)
                    file=$(ls -SrA $path | head -n 2 | tail -n 1)
                    pastSize=$(stat -c%s $path'/'$file)
                    count=1
                    for file in $files; do
                        newSize=$(stat -c%s $path'/'$file)
                        if [ $pastSize -eq $newSize ]; then
                            count=$((count + 1))
                        else
                            echo "The number of files with the size $pastSize is $count"
                            count=1
                            pastSize=$newSize
                        fi
                    done
                ;;
                5)  # Sort and count by type (files, directories, links)
                    clear
                    ls -lXA $path | less
                    echo "Count by type:"
                    files=$(ls -A $path)
                    count_files=0
                    count_dirs=0
                    count_links=0
                    for f in $files; do
                        if [ -f "$path/$f" ]; then
                            count_files=$((count_files + 1))
                        elif [ -d "$path/$f" ]; then
                            count_dirs=$((count_dirs + 1))
                        elif [ -L "$path/$f" ]; then
                            count_links=$((count_links + 1))
                        fi
                    done
                    echo "Files: $count_files"
                    echo "Directories: $count_dirs"
                    echo "Links: $count_links"
                ;;
            esac
        ;;
        2)  # Filtering options
            clear
            echo "Do you want to include subdirectories? (y/n)"
            read -p "Enter choice: " recursive

            echo "1. Display files that start with a given string"
            echo "2. Display files that end with a given string"
            echo "3. Display files that contain a given string"
            read -p "Enter your option: " submenu2

            case $submenu2 in
                1)  # Starts with string
                    clear
                    read -p "Enter the string: " string
                    if [ "$recursive" = "y" ]; then
                        find "$path" -type f -name "$string*"
                    else
                        ls -A "$path/$string"*
                    fi
                ;;
                2)  # Ends with string
                    clear
                    read -p "Enter the string: " string
                    if [ "$recursive" = "y" ]; then
                        find "$path" -type f -name "*$string"
                    else
                        ls -A "$path/"*"$string"
                    fi
                ;;
                3)  # Contains string
                    clear
                    read -p "Enter the string: " string
                    if [ "$recursive" = "y" ]; then
                        find "$path" -type f -name "*$string*"
                    else
                        ls "$path/"*"$string"*
                    fi
                ;;
            esac
        ;;
        3)  # Exit program
            clear
            break
        ;;
    esac
done
