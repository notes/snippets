#!/bin/sh

RPM=$1

if [ "$#" -gt 1 ]
then
  shift
  ./rpm2cpio.py "$RPM" | cpio -iv "$@"
else
  ./rpm2cpio.py "$RPM" | cpio -itv
fi

