# Report Peripheral Battery

This shell script retrieves, and reports on, the battery status of Apple peripheral devices such as the Magic Mouse, Keyboard and Trackpad. This allows devices to be charged timely, during downtime.

The status is printed to <stdout> and a system notification is thrown below a chosen battery percentage threshold.

## Requirements

Tested on MacOS Big Sur. Might work on other releases.

## Todo

- [x] Move scheduling from cron to launchd
- [x] Only report when battery status changed
- [ ] Make script self-updating on run
- [ ] Move todo to GitHub project boards

## Usage

### Run from the command line

```sh
./report-peripheral-battery [battery-percentage-threshold]
```

With `[battery-percentage-threshold]` an optional battery percentage treshold. Run without any arguments to use and see the default.

### Schedule as a launchd agent

Make the project files accessible to all users of a machine by placing it in `/Users/Shared`. For a single user; a more limited location such as ~/Applications can be used.

By making a shallow clone of the git repository (using `--depth 1`), only the most recent changes are downloaded.

```sh
git clone --depth 1 https://github.com/averstuyf/av-tool-report-peripheral-battery.git /Users/Shared/av-tool-report-peripheral-battery/
```

Make a symlink to the [launchd agent config](https://manpagez.com/man/5/launchd.plist/) file in `/Library/LaunchAgents` for all users or `~/Library/LaunchAgents` for a specific user.

```sh
sudo ln -s /Users/Shared/av-tool-report-peripheral-battery/com.av.report-peripheral-battery.plist /Library/LaunchAgents/com.av.report-peripheral-battery.plist
```

Have launchd load the agent.

```sh
launchctl load /Library/LaunchAgents/com.av.report-peripheral-battery.plist
```

See script output and errors.

```sh
cat /tmp/report-peripheral-battery.stdout
cat /tmp/report-peripheral-battery.stderr
```

## Acknowledgements

- [Get low battery notifications for mouse earlier](https://apple.stackexchange.com/questions/254703/get-low-battery-notifications-for-mouse-earlier/327627#327627) - Stack Exchange

## License

This repository is [licensed](LICENSE.md) under the permissive MIT License.

---

Copyright (c) 2020 [Arnaud Verstuyf](https://github.com/averstuyf)
