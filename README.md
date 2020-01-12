# iOS Remote control for external monitor

## Run on mac start

Modify daemon startup plist

```plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:</string>
    </dict>
    <key>Label</key>
    <string>com.monitorcontrol</string>
    <key>Program</key>
    <string>/Users/igor/GO/workspace/monitorcontrol/start.sh</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>LaunchOnlyOnce</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/startup.stdout</string>
    <key>StandardErrorPath</key>
    <string>/tmp/startup.stderr</string>
    <key>UserName</key>
    <string>igor</string>
    <key>GroupName</key>
    <string>admin</string>
    <key>InitGroups</key>
    <true/>
  </dict>
</plist>
```

Copy file to 
`cp com.monitorontrol.plist /Library/LaunchDaemons/`

Load the `launchd` startup

`sudo launchctl load -w /Library/LaunchDaemons/com.monitorcontrol.plist`

-w flag permanently removes the plist from the Launch Daemon
`sudo launchctl unload -w /Library/LaunchDaemons/com.monitorcontrol.plist`

Once a script is added onto the Launch Daemon it will auto-start even if the user runs the following command

You can stop the launchctl process by
`sudo launchctl stop /Library/LaunchDaemons/com.monitorcontrol.plist`
You can start the launchctl process by
`sudo launchctl start -w /Library/LaunchDaemons/com.monitorcontrol.plist`

