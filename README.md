# iOS Remote control for external monitor

iOS Remote control for external monitor is made to remotely control the external monitor connected to the computer.

**Motivation:** I use my 4K monitor as bedroom TV and as a part of my software development ansamble. It has Chromecast connected on HDMI port and DisplayPort connecting to MacBook Pro. When done watching Netflix, HBO, ... I don't feel like getting up from my bed to push Off button on the monitor since streaming is all done through the iPhone or iPad.

This setup was only tested on **MacOS Catalina 10.15.2**, **MacBook Pro (15-inch, 2016) with Intel graphics** and external monitor **ViewSonic VP3268-4K PRO 32" 4K Monitor**. 

The iOS app is built for iOS 13. 

![iOS monitor control screen](https://user-images.githubusercontent.com/17519105/72224723-66598080-3532-11ea-8d00-4a94edb020cd.png "Monitor control screen")
![gif_video_ios_remote_control](https://user-images.githubusercontent.com/17519105/72227549-bba58a00-3552-11ea-8dc5-633d95446677.gif)

# Components

## Server

The server component is written in GO language and it's using [DDC monitor controls for Mac OSX command line](https://github.com/kfix/ddcctl)

## DDC/CI 

DDC/CI protocol implementation for MacOS X is taken kfix repository [DDC monitor controls for Mac OSX command line](https://github.com/kfix/ddcctl)

## iOS APP

iOS App is written in Swift 5 and target iOS 13.0

# Install

- install XCode
- figure out if your Mac is using an Intel, Nvidia or AMD gpu
- Install GO

Run build script (provide either intel,nvidia or gpu argument). 
Example:

`
./build.sh intel
`

# Run

Start the server:  

`
./start.sh
`

Validate that the server is running, open browser and enter URL: `http://localhost:7800/monitors`

You should see JSON response as an empty array or if you have an external display connected there should be monitor in the list. 

# Start server on macOS X start

Modify daemon startup plist with the path to your `start.sh` script

```
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

# Validate that Daemon is running

Open browser and visit this url: 
`http://localhost:7800/monitors`

Result should display an empty list if currently you don't have an external monitor connected or an external monitors' name
