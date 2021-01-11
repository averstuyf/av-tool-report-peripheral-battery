#!/bin/sh
VERSION="3"

# Default threshold at 15%. Overridden by the first argument
BATTERY_PERCENTAGE_THRESHOLD=${1:-15}

TIMESTAMP=$(date +"%Y-%m-%d %T")
printf "Backup - version: %s, timestamp: %s, battery percentage threshold: %s%%\n" "$VERSION" "$TIMESTAMP" "$BATTERY_PERCENTAGE_THRESHOLD"

# Check each device
for device in Mouse Keyboard Trackpad; do
    # Retrieve battery level of device
    battery_percentage=`ioreg -c AppleDeviceManagementHIDEventService -r -l \
         | grep -i $device -A 20 | grep BatteryPercent | sed -e 's/.* //'`

    # Guard against the device not being found
    if [ -z "$battery_percentage" ]; then
      printf "%s not found.\n" $device
      continue
    fi

    # Report appropriately
    message="$device battery at ${battery_percentage}%."
    echo $message

    if (( battery_percentage < BATTERY_PERCENTAGE_THRESHOLD )); then
      osascript -e "display notification \"$message\" with title \"$device Battery Low\""
    fi
done

echo
