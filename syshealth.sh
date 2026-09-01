#!/usr/bin/env bash
# ==================================
# syshealth.sh - System Health & Log Analysis Toolkit
# Lab 1 - Data Collector 
# Author: Nadine Soltan
# Date: $(2026-08-29)
# ==================================
# --- Variables and quoting demonstration ---

# The $(command) gets the output of that command
# For variables, it gets the text stored inside the variable

# This will store the computer's hostname in a variable
HOSTNAME=$(hostname)

# This will store the current date and time in a variable
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Without the quotes, the command will display the hostname without quotation marks
echo "Hostname without quotes: $HOSTNAME"

#With the quotes, the command displays the hostname with quotation marks
echo "Hostname with quotes: \"$HOSTNAME\""


cat << EOF
EOF

# --- System metrics collection ---

# This command displays how long computer has been running in simple format
# The -p stands for pretty
UPTIME=$(uptime -p)

# This command displays disk usage for main sttorage drive
# The df -h shows all drives and their used space in readable format (gb/mb)
# The | is a pipe, sends the list to next command
# The tail -1 filters to only show last line of the list
DISK_USAGE=$(df -h / | tail -1)

# This command filters RAM usage
# The free -h shows total,used,and available RAM in readable format (gb/mb)
# The | is a pipe, send memory data to next command
# The awk command scans text line by line 
# The '/Mem:/ searches for line containing the word Mem:
# The command prints third column (used), slash, and second column (total)
MEMORY_USAGE=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

# This command counts total num of active processes running in the system
# The ps -e lists every process running actively
# The wc -l counts the lines of text it receives
PROCESS_COUNT=$(ps -e | wc -l)

# --- Output handling ---

# The ${1:-value} gives a default value if first argument is not there
# The $1 is the first input parameter passed to script
# The :-  means if empty, use what comes next
OUTPUT_FILE="${1:-}"   # if $1 is given, use it; else print to screen

# This part  prints all the information in a formatted way
# The %s\n means %s placeholder that accepts string, \n means newline
print_report() {
printf "=====================================\n"
printf "System Health Report - %s\n" "$CURRENT_DATE"
printf "Hostname      : %s\n" "$HOSTNAME"
printf "Uptime        : %s\n" "$UPTIME"
printf "Disk /        : %s\n" "$DISK_USAGE"
printf "Memory used   : %s\n" "$MEMORY_USAGE"
printf "Total processes : %s\n" "$PROCESS_COUNT"
printf "=====================================\n"
}

# This script saves the report to a file if filename is provided
# If filename is not provided, it prints report to screen
# The if statement checks if variable is not empty
if [ -n "$OUTPUT_FILE" ]; then
    print_report > "$OUTPUT_FILE" # This runs the report function
# And it saves output into the file ^
    echo "Report written to $OUTPUT_FILE" # Prints confirmation message to screen
else # Will run if variable is empty 
    print_report # Prints report to screen
fi # Ends if statement block

exit 0 # Closes script and  signals succesful ennding

