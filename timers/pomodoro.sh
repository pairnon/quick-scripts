#!/bin/bash

# Define the durations for focus, pause, and long pause in seconds
declare -A TIMES=(
    [FOCUS]=1800
    [PAUSE]=300
    [LONG_PAUSE]=600
)

# Number of focus slices before a long pause is earned
NUM_ITERATIONS=3

# Prompt the user for the pomodoro type
echo -e "\e[0;35mSelect pomodoro type:\e[0m"
echo "1. Short (5 minutes focus, 1 minute pause)"
echo "2. Medium (30 minutes focus, 5 minutes pause)"
echo "3. Long (60 minutes focus, 10 minutes pause)"
read -p "Enter your choice (1, 2, or 3): " interval_choice

# Validate the input
if ! [[ $interval_choice =~ ^[1-3]$ ]]; then
    echo "Invalid choice. Please enter 1, 2, or 3."
    exit 1
fi

# Adjust the durations based on the user's choice
case $interval_choice in
    1)
        TIMES[FOCUS]=300
        TIMES[PAUSE]=60
        ;;
    2)
        TIMES[FOCUS]=1800
        TIMES[PAUSE]=300
        ;;
    3)
        TIMES[FOCUS]=3600
        TIMES[PAUSE]=600
        ;;
esac

# Initialize the current state
state="FOCUS"
iteration=0

# Function to display the timer
display_timer() {
    local remaining=$((TIMES[$state] - $(($(date +%s) - start_time))))
    echo -ne "\e[0;32mTime remaining: $(date -u --date @$remaining +%H:%M:%S)\r\e[0m"
}

# Main loop
while true; do
    # Start the timer for the current state
    start_time=$(date +%s)
    echo -e "\e[0;34mStarting $state period...\e[0m"

    # Loop until the timer ends
    while [ $(date +%s) -lt $((start_time + TIMES[$state])) ]; do
        display_timer
        sleep 1
    done

    # Check if it's time for a long pause
    if [ "$state" == "FOCUS" ]; then
        iteration=$((iteration + 1))
        if [ $iteration -ge $NUM_ITERATIONS ]; then
            state="LONG_PAUSE"
            iteration=0
        else
            state="PAUSE"
        fi
    else
        state="FOCUS"
    fi

    # Alert user
    echo -e "\nTimer finished."
    echo -e "\nPlaying alert sound..."
    paplay Nokia_tune.ogg

    # Wait for user input to control the timer
    read -n 1 -s -p "Press P to pause/resume or Q to quit: " input
    case $input in
        p|P)
            # Pause or resume
            ;;
        q|Q)
            # Quit the script
            echo -e "\n"
            exit 0
            ;;
    esac
done
