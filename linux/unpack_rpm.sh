#!/bin/sh

RPM=$1

# cpio options
#   -i: read input (i.e. extract)
#   -v: print filename during processing
#   -d: create directories automatically
if [ "$#" -gt 1 ]; then
  shift
  ./rpm2cpio.py "$RPM" | cpio -ivd $@
else
  ./rpm2cpio.py "$RPM" | cpio -ivd
fi

