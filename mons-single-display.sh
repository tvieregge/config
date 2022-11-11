#!/bin/sh
#
# This script is based off of "secondary" and "primary" display This isn't very
# realiable, but is very general. It gets messed up if you select the external
# monitor as primary, but should work with any laptop.
#
# An alternative would be to `mons -S` and specify the display number

case ${MONS_NUMBER} in
    1)
        mons -o
        ;;
    2)
        mons -s
        ;;
    *)
        ;;
esac
