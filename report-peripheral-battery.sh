#!/bin/sh
VERSION="3"

# Default to warn below 15%. Overridden by the first argument
BATTERY_PERCENTAGE_THRESHOLD=${1:-15}

# The -t test option checks whether the stdin, [ -t 0 ],
#+ or stdout, [ -t 1 ], in a given script is running in a terminal
IS_INTERACTIVE=$(test -t 0)

# Make sure any necessary apps can be found outside of a terminal
! ($IS_INTERACTIVE) && PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Check each device
for device in Mouse Keyboard Trackpad; do
    # Retrieve battery level of device
    battery_percentage=`ioreg -c AppleDeviceManagementHIDEventService -r -l \
         | grep -i $device -A 20 | grep BatteryPercent | sed -e 's/.* //'`

    # Guard against the device not being found
    if [ -z "$battery_percentage" ]; then
      ($IS_INTERACTIVE) && printf "%s not found.\n" $device
      continue
    fi

    # Report appropriately
    message="$device battery is at ${battery_percentage}%."
    if ( $IS_INTERACTIVE ); then
      printf "Battery percentage threshold is set to %s%%.\n" $BATTERY_PERCENTAGE_THRESHOLD
      echo $message
    fi
    if (( battery_percentage < BATTERY_PERCENTAGE_THRESHOLD )); then
      osascript -e "display notification \"$message\" with title \"$device Battery Low\""
    fi
done