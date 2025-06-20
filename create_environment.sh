#!/bin/bash

echo "=== Submission Reminder App Environment Setup ==="
echo

read -p "Enter your name: " user_name

if [[ -z "$user_name" ]]; then
    echo "Error: Name cannot be empty!"
    exit 1
fi

app_dir="submission_reminder_${user_name}"
echo "Creating directory: $app_dir"

if [[ -d "$app_dir" ]]; then
    echo "Warning: Directory $app_dir already exists. Removing and recreating..."
    rm -rf "$app_dir"
fi

mkdir -p "$app_dir"

echo "Creating subdirectories..."
mkdir -p "$app_dir/app"
mkdir -p "$app_dir/modules" 
mkdir -p "$app_dir/assets"
mkdir -p "$app_dir/config"

echo "Creating config.env..."
cat > "$app_dir/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

echo "Creating functions.sh..."
cat > "$app_dir/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

echo "Creating reminder.sh..."
cat > "$app_dir/app/reminder.sh" << 'EOF'
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
EOF

echo "Creating submissions.txt with additional student records..."
cat > "$app_dir/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Michael, Shell Navigation, submitted
Sarah, Git, not submitted
James, Shell Basics, not submitted
Lisa, Shell Navigation, submitted
Kevin, Git, not submitted
EOF

echo "Creating startup.sh script..."
cat > "$app_dir/startup.sh" << 'EOF'
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
EOF

echo "Setting executable permissions for all .sh files..."
find "$app_dir" -name "*.sh" -type f -exec chmod +x {} \;

echo
echo "========================================="
echo "    Environment Setup Complete! ✓"
echo "========================================="
echo
echo "Created directory: $app_dir"
echo "Directory structure:"
echo "├── app/"
echo "│   └── reminder.sh"
echo "├── modules/"
echo "│   └── functions.sh"
echo "├── assets/"
echo "│   └── submissions.txt (now with 9 student records)"
echo "├── config/"
echo "│   └── config.env"
echo "└── startup.sh"
echo
echo "All .sh files have been made executable."
echo
echo "To test the application:"
echo "1. cd $app_dir"
echo "2. ./startup.sh"
echo
