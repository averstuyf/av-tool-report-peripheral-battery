#!/bin/sh
VERSION="4"

STATUS_FILENAME_PREFIX='.device-battery-percentage'
STATUS_FILENAME_PATH=$HOME

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

    # Retrieve the previously reported battery level
    status_filename="${STATUS_FILENAME_PATH}/${STATUS_FILENAME_PREFIX}.${device}"
    previous_battery_percentage=$(<$status_filename)

    # Guard against reporting the same level more than once in a row
    if [ "$battery_percentage" ==  "$previous_battery_percentage" ]; then
      printf "Identical %s battery at %s%%. Skip reporting.\n" $device $battery_percentage
      continue
    fi

    # Store the battery level
    echo $battery_percentage > $status_filename

    # Report appropriately
    message="$device battery at ${battery_percentage}%."
    echo $message

    if (( battery_percentage < BATTERY_PERCENTAGE_THRESHOLD )); then
      # https://code-maven.com/display-notification-from-the-mac-command-line
      osascript -e "display notification \"$message\" with title \"$device Battery Low\""
    fi
done

echo
