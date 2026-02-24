#!/bin/bash

# --- Configuration ---
# Colors (ANSI escape sequences)
COLOR_HEADER='\033[1;32m' # Green
COLOR_PATH='\033[1;31m'   # Red
COLOR_RESET='\033[0m'

# Tree configuration
TREE_DEPTH=2
TREE_IGNORE="'Icon?'"
TREE_CMD="tree -C -F -L $TREE_DEPTH --dirsfirst --noreport -h -I $TREE_IGNORE"

# --- Main Script ---
# Run watch with the full status dashboard
# We use printf and escaped characters carefully to ensure compatibility with sh inside watch
watch -t -c "
  printf \"${COLOR_HEADER} --- Current Directory --- ${COLOR_RESET}\n${COLOR_PATH} %s${COLOR_RESET}\n\n\" \"\$PWD\"
  $TREE_CMD

  echo \"\"
  printf \"${COLOR_HEADER} --- System Stats --- ${COLOR_RESET}\n\"
  printf \"CPU Load:    %s\n\" \"\$(sysctl -n vm.loadavg | awk '{print \$2, \$3, \$4}')\"
  printf \"Mem Usage:   %s\n\" \"\$(top -l 1 | grep PhysMem | awk '{print \$2 \" /\" \$6 \"\"}')\"
  printf \"Disk Space:  %s\n\" \"\$(df -h / | awk 'NR==2 {print \$5}')\"
  printf \"Uptime:      %s\n\" \"\$(uptime | sed 's/.*up //; s/, [0-9]* users.*//')\"
  printf \"\n\"
"
