1. Build project.

2. Locate executable (right-click under Products, then Show in Finder).

3. Copy executable to system bin directory of choice (e.g. /usr/bin/), renaming it to 'sleepd'.

4. Make executable by root, or desired user (e.g. chown root:wheel /usr/bin/sleepd)

5. Copy project .plist file to /Library/LaunchDaemons, and set ownership/permissions to match other .plist files

6. Inspect .plist file to account for any customizations / renaming in previous steps.

7. Activate daemon with (normally, as root):

   >> launchctl load -w /Library/LaunchDaemons/com.enscand.sleepd.plist


Help - nathan@enscand.com