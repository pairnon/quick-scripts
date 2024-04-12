#!/bin/bash

# Prompt the user for the duration in seconds
echo -e "\e[0;35mEnter the duration in seconds:\e[0m"
read duration

# Validate the input
if ! [[ $duration =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number."
    exit 1
fi

# Start the timer
echo "Starting the timer for $duration seconds..."

# Calculate the end time
end_time=$(($(date +%s) + duration))

# Loop until the timer ends
while [ $(date +%s) -lt $end_time ]; do
    # Calculate the remaining time
    remaining_time=$((end_time - $(date +%s)))
    
    # Display the remaining time
    echo -ne "Time remaining: $(date -u --date @$remaining_time +%H:%M:%S)\r"
    
    # Wait for 1 second before updating the display
    sleep 1
done

# Timer finished
echo -e "\nTimer finished."
echo -e "\nPlaying alert sound..."
paplay Nokia_tune.ogg
