#!/bin/bash

echo "============================================"
echo "  Submission Reminder Application Startup  "
echo "============================================"
echo

echo "Verifying application components..."

required_dirs=("app" "modules" "config" "assets")
for dir in "${required_dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
        echo "Error: Required directory '$dir' not found!"
        echo "Please run create_environment.sh first."
        exit 1
    fi
done

required_files=("app/reminder.sh" "modules/functions.sh" "config/config.env" "assets/submissions.txt")
for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Error: Required file '$file' not found!"
        echo "Please run create_environment.sh first."
        exit 1
    fi
done

echo "All components verified ✓"
echo "Starting reminder application..."
echo

cd app
source "../config/config.env"
source "../modules/functions.sh"

echo "Available functions in this application:"
echo "- check_submissions: Check submissions for current assignment"
echo
echo "Current assignment: $ASSIGNMENT"
echo "Days remaining: $DAYS_REMAINING"
echo

check_submissions "../assets/submissions.txt"

cd ..
echo
echo "Application finished. Thank you!"
