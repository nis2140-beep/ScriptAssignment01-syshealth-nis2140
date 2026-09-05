#!/usr/bin/env bash
# ==================================
# syshealth.sh - System Health & Log Analysis Toolkit
# Lab 1 - Data Collector 
# Author: Nadine Soltan
# Date: $(date +%Y-%m-%d)
# ==================================
# --- Variables and quoting demonstration ---

# The $(command) runs the command and stores the output 
# The $VARIABLE accesses the value already stored inside the variable

# This will store the computer's hostname in a variable
HOSTNAME=$(hostname)

# This will store the current date and time in a variable
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Without the quotes, the command will display the hostname without quotation marks around its value
# Unquoted variables can be split into multiple words if their values have spaces
# This is important especially in cases where a variable has spaces and special characters
echo "Hostname without quotes: $HOSTNAME"

#With the quotes, the command displays the hostname with quotation marks
# Double quoting is generally safer in bash because it keeps the variable value together as one value
# This is important especially in cases where a variable has spaces and special characters
echo "Hostname with quotes: \"$HOSTNAME\""

# --- System metrics collection ---

# This command displays how long the computer has been running in simple format
# The -p stands for pretty format, it prints the system's uptime in an easy to read format for humans
UPTIME=$(uptime -p)

# This command displays disk usage for the main storage drive
# The df -h / shows how much free and used disk space is on the main root filesystem of the computer in readable format (mb/gb)
# The | is a pipe, sends the output of one command to the next
# The tail -1 filters to only show last line of the df output
DISK_USAGE=$(df -h / | tail -1)

# This command filters RAM usage
# The free -h shows total,used,and available RAM in readable format (gb/mb)
# The | is a pipe, it sends memory data to next command
# The awk command scans text line by line 
# The '/Mem:/' searches for line containing the word Mem:
# The command prints third column (used), slash, and second column (total)
MEMORY_USAGE=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

# This command counts total number of active processes running in the system
# The ps -e lists every process running on the system
# The wc -l counts the lines of text it receives
PROCESS_COUNT=$(ps -e | wc -l)

# --- Output handling ---

# The ${1:-} gives uses first argument if given, if first argument is not there it gives an empty value
# The $1 is the first input parameter passed to script

OUTPUT_FILE="${1:-}"   # if $1 is given, use it; else print to screen

# The %s is a placeholder for a string,and \n creates a newline
# This function prints all the system information in a clear,structured,formatted way
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
    # This runs the report function and redirects its output into given file
    print_report > "$OUTPUT_FILE"
   
    # Prints confirmation message to screen
    echo "Report written to $OUTPUT_FILE" 
else
    # Will run if variable is empty, prints report to screen 
    print_report 

fi # Ends if statement block

exit 0 # Closes script and signals successful ending with status 0

