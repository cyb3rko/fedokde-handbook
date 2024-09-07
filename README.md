# Fedora KDE Handbook

System info: (Fedora Workstation + KDE Plasma Wayland)

---

- [Resource Management](#resource-management)
  - [Large file and folder monitor](#large-file-and-folder-monitor)
  - [Find large files](#find-large-files)
  - [AutoTrash](#autotrash)
- [Services](#services)
  - [dnf Optimization](#dnf-Optimization)
  - [SSH Session Keep-Alive](#ssh-session-keepalive)
  - [Java](#java)
  - [GitHub Authentication](#github-authentication)
  - [Howdy Face Recognition](#howdy-face-recognition)
  - [Remove KDE Stuff](#remove-kde-stuff)
  - [Remove Gnome Junk](#remove-gnome-junk)
  - [Remove Libre Office](#remove-libre-office)
  - [Remove unused firmware](#remove-unused-firmware)
  - [Remove other unused pre-installed stuff](#remove-other-unused-pre-installed-stuff)
- [Nvidia Graphics](#nvidia-graphics)
- [Applications](#applications)
  - [Firefox](#firefox)
  - [OneDrive](#onedrive)
  - [Jetbrains Toolbox](#jetbrains-toolbox)
  - [yt-dlp](#yt-dlp)

## Resource Management

### Large file and folder monitor

Use the CLI tool ncdu for a simple overview of the largest files and folders.

```shell
sudo dnf install ncdu -y
ncdu /
```

### Find large files

Find files in current directory with a specified minimum size (in this example 100 MB)

```shell
find . -type f -size +100M
```

### Autotrash

To automatically clear older files in the trash, run the following (example: files older than 40 days):

```shell
sudo dnf install pipx
pipx install autotrash
```

```shell
autotrash -d 40 --install
```

## Services

### dnf Optimization

Change the following entries at `/etc/dnf/dnf.conf`:

```shell
max_parallel_downloads=10
deltarpm=True
fastestmirror=True
```

### SSH Session Keep-Alive

Edit `/etc/ssh/ssh_config` and append:

```shell
ServerAliveInterval 60
```

### Java

To install the correct version do:

```shell
dnf search opendjk
sudo dnf install ...
```

To switch between installed java versions do:

```shell
sudo alternatives --config java
```

### GitHub Authentication

```shell
ssh-keygen -t ed25519 -f /home/niko/.ssh/id_github_ed25519
```

Add to config at `/home/niko/.ssh/config`:

```shell
Host github.com
  User git
  IdentityFile ~/.ssh/id_github_ed25519
```

Example remote config:

```shell
git remote set-url origin git@github.com:cyb3rko/fedokde-handbook.git
```

### Howdy Face Recognition

Install it via:

```shell
dnf copr enable principis/howdy
dnf --refresh install howdy
```

Find your available cameras with `ls /dev/video*` and remember the name of your infrared camera.  
Paste the camera path in the config at `sudo howdy config` in the line `device_path`.

Test the camera with `sudo howdy test` and change it until you find the infrared camera.

Allow Howdy authentication for `sudo` at `/etc/pam.d/sudo`:

```shell
auth       sufficient   pam_python.so /lib64/security/howdy/pam.py
...
```

Allow Howdy authentication for the KDE lockscreen at `/etc/pam.d/kde`:

```shell
auth        [success=done ignore=ignore default=bad] pam_selinux_permit.so
auth        sufficient    pam_python.so /lib64/security/howdy/pam.py
auth        substack      password-auth
...
```

Manually create the snapshots folder:

```shell
sudo mkdir /usr/lib64/security/howdy/snapshots
```

### Hide unused built-in applications

```shell
sudo cp /usr/share/applications/{org.kde.contactprintthemeeditor.desktop,org.kde.contactthemeeditor.desktop,org.kde.headerthemeeditor.desktop} /home/niko/.local/share/applications && \
for file in /home/niko/.local/share/applications/org.kde.*themeeditor.desktop; \
do sudo chown niko:niko $file && echo "NoDisplay=true" >> $file; done
```

### Remove KDE Stuff

```shell
sudo yum autoremove plasma-welcome akregator kaddressbook khelpcenter kmahjong korganizer kpat
```

### Remove Gnome Junk

```shell
sudo yum autoremove gnome-keyring*
```

### Remove Libre Office

```shell
sudo yum autoremove libreoffice*
```

### Remove unused firmware

```shell
sudo yum autoremove amd-gpu-firmware cirrus-audio-firmware
```

### Remove other unused pre-installed stuff

```shell
sudo yum autoremove bluez mariadb minicom sos speech-dispatcher words
```

## Nvidia Graphics

To enable support for Nvidia Graphics Cards using Wayland do the following:

```shell
sudo dnf upgrade -y
sudo dnf install kmodtool akmods mokutil openssl
sudo kmodgenca -a
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
```

```shell
systemctl reboot
```

Add free + nonfree rpm fusion repos: https://rpmfusion.org/Configuration.

Then:

```shell
sudo dnf update
sudo dnf install akmod-nvidia
sudo dnf install xorg-x11-drv-nvidia-cuda
```

Wait a few minutes, until...

```shell
modinfo -F version nvidia
```

prints out the module version.

Then:

```shell
systemctl reboot
```

## Applications

### Firefox

To apply policies to Firefox via the [policies.json](firefox/policies.json), just place it at `/etc/firefox/policies`.  
Move or delete the default Fedora config at `/usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js`.  
Restart Firefox and find applied policies at `about:policies`.

Custom configs not available with the centralized policy configuration:

- `full-screen-api.warning.timeout`: 0 (disables the fullscreen popup)
- `reader.parse-on-load.enabled`: false (disables the simplified reader mode)
- remove all removable search keywords in the search settings

### OneDrive

Install [abraunegg/onedrive](https://github.com/abraunegg/onedrive):

```shell
sudo dnf install onedrive -y
```

To allow logging to `/var/log/onedrive`, do the following:

```shell
sudo mkdir /var/log/onedrive
sudo chown root:niko /var/log/onedrive
sudo chmod 0775 /var/log/onedrive
```

Initialize onedrive:  
```shell
onedrive
```

After initializing onedrive and BEFORE running the first sync, copy [config](onedrive/config) and [sync_list](onedrive/sync_list) to `~/.config/onedrive/`. Check the config with `onedrive --display-config`.

First sync:  
`onedrive --resync --sync`

### Jetbrains Toolbox

Install via one-liner:
```shell
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | sed 's/ --show-progress//' | bash
```

### yt-dlp

```shell
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
```
