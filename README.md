##Description

This is a Cocoa command line application designed to be installed on an OS X system as a persistent daemon process. The daemon receives
notifications when the OS X system sleeps or wakes, and allows the user to configure a script (with command line args) to be run,
on wake and sleep events.

##Installation of Daemon

1. **Build** project.

2. Locate executable (right-click under **Products**, then **Show in Finder**).

3. Copy executable to system bin directory of choice (e.g. `/usr/bin/`), renaming it to `sleepd`.

4. Make executable by root, or desired user (e.g. `chown root:wheel /usr/bin/sleepd`)

5. Copy project .plist file to `/Library/LaunchDaemons`, and set ownership/permissions to match other .plist files

6. Inspect .plist file to account for any customizations / renaming in previous steps.

7. Activate daemon with (normally, as root):

    launchctl load -w /Library/LaunchDaemons/com.mycompany.sleepd.plist


##Help 

 mail -  n8r0n74@gmail.com
