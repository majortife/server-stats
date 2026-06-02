#!/bin/bash
if [ "$EUID" -eq 0 ]; then
    ROOT_ACCESS=true
else
    ROOT_ACCESS=false
fi

#display OS Version 
echo "OS version: $(cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f2)"
echo ""

echo "Uptime: $(uptime -p)"
echo ""

#Details on users
unique_users=$(who | awk '{print $1}' | sort -u)
echo "Logged in users:"
echo "$unique_users"
echo "Total users: $(echo "$unique_users" | wc -l)"
echo ""

#find total cpu usage
cpu_usage=$(top -bn2 | grep "Cpu(s)" | tail -n 1 | awk '{print 100 - $8}')
echo "CPU usage is: ${cpu_usage}"
echo ""

#Disk usage
disk_used=$(df -h |grep " /$" | awk '{print $5+0}')
echo "Percentage of disk space used: $disk_used%"
echo "Percentage of disk space free: $((100 - $disk_used))%"
echo ""

#Memory usage
memory_used=$(free | grep "Mem" |awk '{printf "%.0f", $3 / $2 * 100}')
echo "Percentage of memory used: $memory_used%"
echo "Percentage of memory free:  $(( 100 - memory_used ))%"
echo ""
# Top 5 Processes sorted by the CPU usage
echo "Top 5 Processes sorted by the CPU usage:"
echo "PID  %CPU  COMMAND"
ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {print $2, $3, $11}'
echo ""

# Top 5 Processes sorted by the Memory usage
echo "Top 5 Processes sorted by the Memory usage:"
echo "PID  %MEM  COMMAND"
ps aux --sort=-%mem | awk 'NR>1 && NR<=6 {print $2, $4, $11}'
echo ""

if [ "$ROOT_ACCESS" = true ]; then
    echo "=== FAILED LOGIN ATTEMPTS (last 5) ==="
    if command -v journalctl &> /dev/null; then
        journalctl _COMM=sshd 2>&1 | grep -E "Failed password|Invalid user" | tail -5
    elif [ -r /var/log/auth.log ]; then
        grep -E "Failed password|Invalid user" /var/log/auth.log 2>/dev/null | tail -5
    elif [ -r /var/log/secure ]; then
        grep -E "Failed password|Invalid user" /var/log/secure 2>/dev/null | tail -5
    else
        echo "Unable to check failed logins"
    fi
else
    echo "=== FAILED LOGIN ATTEMPTS ==="
    echo "Run with sudo to see failed login attempts"
fi
