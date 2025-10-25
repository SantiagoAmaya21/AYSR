#!/bin/bash

# Script to create a new user with specific attributes and permissions

# Parameters passed to the script
name=$1                # Username to be created
group=$2               # Primary group of the user
description=$3         # User description or comment field
directory=$4           # Home directory for the user
shell=$5               # Default shell for the user
user_permissions=$6    # Permissions for the user's home directory
group_permissions=$7   # Permissions for the group's home directory
other_permissions=$8   # Permissions for the public_html directory

# Check if the specified shell exists in /etc/shells
if grep -q -x "$shell" /etc/shells; then
    # Create the user with the provided attributes
    useradd -m -d "$directory" -s "$shell" -c "$description" -g "$group" "$name"
    
    # Set permissions for the user's home directory
    chmod "$user_permissions" "$directory"

    # If the group home directory exists, set group permissions
    if [ -d "/home/$group" ]; then
        chmod "$group_permissions" "/home/$group"
    fi

    # Create a public_html directory inside the user's home if it does not exist
    if [ ! -d "$directory/public_html" ]; then
        mkdir "$directory/public_html"
    fi
    
    # Set permissions for the public_html directory
    chmod "$other_permissions" "$directory/public_html"
    
    # Set a password for the new user
    passwd "$name"
    
    clear

    # Verify if the user was created successfully
    if id "$name" &>/dev/null; then
        echo "User created successfully"
    else
        echo "The user could not be created"
    fi

else
    # If the shell does not exist in /etc/shells, abort user creation
    clear
    echo "The shell does not exist or is not installed, the user could not be created"
fi
