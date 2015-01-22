#!/bin/bash

# Check to see if argument was supplied
if [ -z "$1" ]
  then
    echo -e "Usage:\nwipe-and-clone-pi.sh /dev/disk#\nWhere # is the disk number as shown by diskutil"
    echo "Do you want to run 'diskutil list' to view all names?"
    select yn in "Yes" "No"; do
      case $yn in
        Yes ) diskutil list; exit;;
        No ) exit;;
      esac
    done
fi

# Save the disk name of the SD card (e.g.: /dev/disk1)
SDCARD_DISK=$1

# Do not let them wipe primary drive /dev/disk0
if [ $1 = "/dev/disk0" ]
  then
    echo "You probably don't want to delete /dev/disk0"
    exit
fi

# Make sure they are sure
echo -e "\nAre you VERY sure you want to wipe $SDCARD_DISK?"
select yn in "Yes" "No" "Run 'diskutil list' to view disk names"; do
  case $yn in
    Yes ) break;;
    No ) exit;;
		"Run 'diskutil list' to view disk names" ) diskutil list; exit;;
  esac
done

# Make sure they are very sure
echo -e "\nVery VERY sure? $SDCARD_DISK will be completely WIPED?"
select yn in "Yes" "No" "Run 'diskutil list' to view disk names"; do
  case $yn in
    Yes ) break;;
    No ) exit;;
		"Run 'diskutil list' to view disk names" ) diskutil list; exit;;
  esac
done

echo -e "\nOk... This should take about 10 minutes or more.\n\nYou don't get much progress feedback so be patient...\n"

# Unmount the disk
diskutil unmountDisk $SDCARD_DISK

# Format the card
sudo newfs_msdos -F 16 $SDCARD_DISK

# Write the image to the card (about 10 mins)
# BBC-pi.dmg has to be in the same directory as this script!
SDCARD_RDISK="${SDCARD_DISK/disk/rdisk}"
BBC_PI_IMAGE=${BASH_SOURCE[0]/%wipe-and-clone-pi.sh/BBC-pi.dmg}
sudo dd if=$BBC_PI_IMAGE of=$SDCARD_RDISK bs=5m

echo -e "\nDone!"