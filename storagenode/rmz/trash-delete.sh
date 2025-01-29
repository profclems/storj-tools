#!/bin/bash

set -e

TARGET_DIR="$1" # directory to scan (passed as argument)
RMZ_BIN="/usr/local/bin/rmz"

# ensure rmz is installed
if [[ ! -x "$RMZ_BIN" ]]; then
    echo "Error: rmz not found in $RMZ_BIN"
    exit 1
fi

# set default target directory if not provided
if [[ -z "$TARGET_DIR" ]]; then
    TARGET_DIR="/app/config/storage/trash"
fi

# ensure target directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi

CURRENT_DATE=$(date +%s)
TOTAL_DELETION_TIME=0
DELETE_COUNT=0

for dir in "$TARGET_DIR"/*; do
    if [[ -d "$dir" && $(basename "$dir") =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        DIR_DATE=$(date -d "$(basename "$dir")" +%s 2>/dev/null || echo 0)
        AGE=$(( (CURRENT_DATE - DIR_DATE) / 86400 ))

        if [[ "$AGE" -ge 7 ]]; then
            echo "Deleting: $dir (Age: ${AGE} days)"

            # Measure deletion time
            START_TIME=$(date +%s.%N)
            "$RMZ_BIN" -f "$dir"
            END_TIME=$(date +%s.%N)

            # Compute elapsed time
            DURATION=$(echo "$END_TIME - $START_TIME" | bc)
            TOTAL_DELETION_TIME=$(echo "$TOTAL_DELETION_TIME + $DURATION" | bc)
            DELETE_COUNT=$((DELETE_COUNT + 1))

            echo "Deleted $dir in ${DURATION}s"
        fi
    fi
done

# Print summary
if [[ "$DELETE_COUNT" -gt 0 ]]; then
    AVERAGE_TIME=$(echo "$TOTAL_DELETION_TIME / $DELETE_COUNT" | bc -l)
    echo "Total directories deleted: $DELETE_COUNT"
    echo "Total deletion time: ${TOTAL_DELETION_TIME}s"
    echo "Average deletion time per directory: ${AVERAGE_TIME}s"
else
    echo "No directories needed deletion."
fi

echo "Cleanup complete."
