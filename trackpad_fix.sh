#!/bin/bash
echo "tim: running fix, $2"
case $1/$2 in
  post/*)
    sleep 1
    echo "tim: fixing trackpad: Waking up from $2..."
    modprobe -r i2c_hid_acpi
    modprobe -r i2c_hid
    modprobe i2c_hid
    modprobe i2c_hid_acpi
    ;;
esac
