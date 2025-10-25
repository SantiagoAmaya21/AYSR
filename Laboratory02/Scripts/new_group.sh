#!/bin/bash
# This script creates a new group in the system.
# It verifies if the group already exists and ensures
# that both the group name and group ID are provided.

# Check if exactly 2 arguments are passed (group name and group ID).
if [ $# -ne 2 ]; then
    echo "Usage: $0 <group_name> <group_id>"
    exit 1
fi

# Assign arguments to variables for clarity.
group_name=$1
group_id=$2

# Check if the group name already exists in /etc/group.
if grep "^$1:" /etc/group > /dev/null; then
    echo "Error: Group '$group_name' already exists."
    exit 1
fi

# Attempt to create the group with the provided GID.
if groupadd --gid "$group_id" "$group_name"; then
    echo "Group '$group_name' created successfully with GID $group_id"
else
    # In case of failure, exit with error status.
    echo "Failed to create group '$group_name'"
    exit 1
fi
