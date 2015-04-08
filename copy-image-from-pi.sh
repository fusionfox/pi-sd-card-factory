#!/bin/bash

# Check to see if arguments were supplied
if [ -z "$1" ] || [ -z "$2" ]
  then
    echo -e "Usage:\ncopy-image-from-pi.sh /dev/disk# image-to-create.dmg\nWhere # is the disk number as shown by diskutil"
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

# Save filename of image to create
IMAGE_FILENAME=$2

# Do not let them copy primary drive /dev/disk0
if [ $1 = "/dev/disk0" ]
  then
    echo "You probably don't want to copy /dev/disk0"
    exit
fi

# Make sure they are sure
echo -e "\nAre you sure you want to copy the contents of $SDCARD_DISK to a file called $IMAGE_FILENAME?"
select yn in "Yes" "No" "Run 'diskutil list' to view disk names"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
        "Run 'diskutil list' to view disk names" ) diskutil list; exit;;
    esac
done

echo -e "\nOk...\n\nYou don't get much progress feedback so be patient...\n"

# Creates an image using the contents of the sd card in the same directory as this script
PI_IMAGE=$(dirname ${BASH_SOURCE[0]})/images/$IMAGE_FILENAME
sudo dd if=$SDCARD_DISK of=$PI_IMAGE

echo -e "\nDone!"