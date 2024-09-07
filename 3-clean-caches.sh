#!/bin/bash
user=$(whoami)
echo "Current user: $user"
if [ "$user" != "niko" ]
then
    echo "Unexpected user"
    exit
fi
user=$(sudo whoami)
echo "Elevated user: $user"
echo "===== Current disk space ====="
df -BM | grep "/dev/sdb"
echo "Cleaning apt-get"
sudo apt-get clean
echo "Cleaning m2"
sudo rm -rf /home/niko/.m2
echo "Cleaning gradle stuff"
sudo rm -rf /home/niko/.gradle/caches
sudo rm -rf /home/niko/.gradle/daemon
sudo rm -rf /home/niko/.gradle/native
sudo rm -rf /home/niko/.gradle/wrapper/dists
sudo rm -rf /home/niko/.gradle/.tmp
echo "Cleaning android cache"
sudo rm -rf /home/niko/.android/cache
sudo rm -rf /home/niko/.android/build-cache
echo "Cleaning python cache"
sudo rm -rf /home/niko/.local/bin/__pycache__
echo "Cleaning npm cache"
sudo rm -rf /home/niko/.npm/_cacache
sudo rm -rf /home/niko/.npm/_logs
echo "Cleaning nv"
sudo rm -rf /home/niko/.nv
echo "Cleaning pub-cache"
sudo rm -rf /home/niko/.pub-cache
echo "Cleaning ui5 cache"
sudo rm -rf /home/niko/.ui5/framework/cacache
echo "Cleaning flatpak cache"
sudo find /var/tmp -type d -name 'flatpak-cache-*' -exec rm -rv "{}" +
echo "Cleaning Toolbox downloads"
sudo rm -rf /home/niko/.cache/JetBrains/Toolbox/download
echo "Cleaning Steam caches"
sudo rm -rf /home/niko/.steam/debian-installation/appcache/librarycache
sudo rm -rf /home/niko/.steam/debian-installation/appcache/httpcache
sudo rm -rf /home/niko/.steam/debian-installation/config/htmlcache
sudo rm -rf /home/niko/.steam/debian-installation/steamapps/shadercache
echo "===== Updated disk space ====="
df -BM | grep "/dev/sdb"
echo "===== Finished ====="
read
