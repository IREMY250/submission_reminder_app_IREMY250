#!/bin/bash

echo "========================================"
echo "    Assignment Configuration Copilot    "
echo "========================================"
echo

app_dir=""
for dir in submission_reminder_*; do
    if [[ -d "$dir" ]]; then
        app_dir="$dir"
        break
    fi
done

if [[ -z "$app_dir" || ! -d "$app_dir" ]]; then
    echo "Error: No submission_reminder_* directory found!"
    echo "Please run create_environment.sh first to set up the application."
    exit 1
fi

echo "Found application directory: $app_dir"

config_file="$app_dir/config/config.env"
if [[ ! -f "$config_file" ]]; then
    echo "Error: config.env file not found at $config_file"
    echo "Please ensure the application is properly set up."
    exit 1
fi

echo "Current configuration:"
echo "======================"
cat "$config_file"
echo "======================"
echo

read -p "Enter the new assignment name: " new_assignment

if [[ -z "$new_assignment" ]]; then
    echo "Error: Assignment name cannot be empty!"
    exit 1
fi

echo
echo "Updating assignment name to: $new_assignment"

# Use sed to replace the ASSIGNMENT value on row 2 (line 2)
sed -i.bak "2s/.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"

if grep -q "ASSIGNMENT=\"$new_assignment\"" "$config_file"; then
    echo "Successfully updated assignment name!"
else
    echo " Failed to update assignment name!"
    exit 1
fi

echo
echo "Updated configuration:"
echo "======================"
cat "$config_file"
echo "======================"
echo

echo "Running startup.sh to check non-submission status for: $new_assignment"
echo "======================================================================"

cd "$app_dir"
./startup.sh

echo
echo "Copilot script completed!"

