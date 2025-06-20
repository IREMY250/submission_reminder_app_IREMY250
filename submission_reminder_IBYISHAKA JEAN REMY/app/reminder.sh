#!/bin/bash

# Load configuration
source "../config/config.env"
source "../modules/functions.sh"

echo "Welcome to $APP_NAME v$VERSION"
echo "=================================="

# Check if submissions file exists
SUBMISSIONS_PATH="../assets/submissions.txt"

if [[ ! -f "$SUBMISSIONS_PATH" ]]; then
    echo "Error: Submissions file not found at $SUBMISSIONS_PATH"
    exit 1
fi

echo
echo "Choose an option:"
echo "1. Show pending submissions"
echo "2. Show all submissions" 
echo "3. Show submission statistics"
echo "4. Exit"
echo

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        check_pending "$SUBMISSIONS_PATH"
        ;;
    2)
        show_all_submissions "$SUBMISSIONS_PATH"
        ;;
    3)
        count_submissions "$SUBMISSIONS_PATH"
        ;;
    4)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
