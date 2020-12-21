#!/bin/sh
VERSION="3"

<<<<<<< HEAD
# Default threshold at 15%. Overridden by the first argument
BATTERY_PERCENTAGE_THRESHOLD=${1:-15}

TIMESTAMP=$(date +"%Y-%m-%d %T")
printf "Backup - version: %s, timestamp: %s, battery percentage threshold: %s%%\n" "$VERSION" "$TIMESTAMP" "$BATTERY_PERCENTAGE_THRESHOLD"
=======
# Default to warn below 15%. Overridden by the first argument
BATTERY_PERCENTAGE_THRESHOLD=${1:-15}

# The -t test option checks whether the stdin, [ -t 0 ],
#+ or stdout, [ -t 1 ], in a given script is running in a terminal
IS_INTERACTIVE=$(test -t 0)

# Make sure any necessary apps can be found outside of a terminal
! ($IS_INTERACTIVE) && PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin
>>>>>>> db192155ce856742dc7ed1b63319d66788f8651e

# Check each device
for device in Mouse Keyboard Trackpad; do
    # Retrieve battery level of device
    battery_percentage=`ioreg -c AppleDeviceManagementHIDEventService -r -l \
         | grep -i $device -A 20 | grep BatteryPercent | sed -e 's/.* //'`

    # Guard against the device not being found
    if [ -z "$battery_percentage" ]; then
<<<<<<< HEAD
      printf "%s not found.\n" $device
=======
      ($IS_INTERACTIVE) && printf "%s not found.\n" $device
>>>>>>> db192155ce856742dc7ed1b63319d66788f8651e
      continue
    fi

    # Report appropriately
<<<<<<< HEAD
    message="$device battery at ${battery_percentage}%."
    echo $message

    if (( battery_percentage < BATTERY_PERCENTAGE_THRESHOLD )); then
      osascript -e "display notification \"$message\" with title \"$device Battery Low\""
    fi
done

echo
=======
    message="$device battery is at ${battery_percentage}%."
    if ( $IS_INTERACTIVE ); then
      printf "Battery percentage threshold is set to %s%%.\n" $BATTERY_PERCENTAGE_THRESHOLD
      echo $message
    fi
    if (( battery_percentage < BATTERY_PERCENTAGE_THRESHOLD )); then
      osascript -e "display notification \"$message\" with title \"$device Battery Low\""
    fi
done
>>>>>>> db192155ce856742dc7ed1b63319d66788f8651e
