# Report Peripheral Battery

This shell script retrieves, and reports on, the battery status of Apple peripheral devices such as the Magic Mouse, Keyboard and Trackpad. This allows devices to be charged timely, during downtime.

The status is printed to <stdout> and a system notification is thrown below a chosen battery percentage threshold.

## Requirements

Tested on MacOS Big Sur. Might work on other releases.

## Usage

### Run from the command line

```sh
./report-peripheral-battery [battery-percentage-threshold]
```

With `[battery-percentage-threshold]` an optional battery percentage treshold. Run without any arguments to use and see the default.

### Add as a recurring cron job

```sh
export VISUAL=nano; crontab -e
```

Add a line containing `*/<repeat-minutes> * * * * <path>/report-peripheral-battery.sh [battery-percentage-threshold]`. With `<repeat-minutes>` the amount of minutes between reports.

E.g.: `*/60 * * * * $HOME/Applications/report-peripheral-battery.sh 12` to check every hour if the battery capacity has dropped below 12%.

## Acknowledgements

- [Get low battery notifications for mouse earlier](https://apple.stackexchange.com/questions/254703/get-low-battery-notifications-for-mouse-earlier/327627#327627) - Stack Exchange

## License

This repository is [licensed](LICENSE.md) under the permissive MIT License.

---

Copyright (c) 2020 [Arnaud Verstuyf](https://github.com/averstuyf)
