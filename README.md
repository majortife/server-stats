# server-stats
A bash script that analyzes basic server performance statistics on any Linux system.

## Features

- OS version detection
- System uptime
- Logged in users (unique list with count)
- Total CPU usage percentage
- Total memory usage (used and free percentages)
- Disk usage for root partition (used and free)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage
- Failed login attempts (last 5) – requires sudo

## Usage

```bash
chmod +x server-stats.sh

# Run without sudo (failed logins skipped)
./server-stats.sh

# Run with sudo (full features)
sudo ./server-stats.sh


Project URL: https://roadmap.sh/projects/server-stats
