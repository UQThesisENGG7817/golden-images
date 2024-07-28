#!/bin/bash

# Remove existing crontabs, if any
rm -f /etc/cron.deny /etc/at.deny /etc/cron.allow /etc/at.allow 

# Set appropriate ownership and permissions for system directories
sysdirs=" \
  /bin \
  /etc \
  /lib \
  /sbin \
  /usr \
  " && \
  find $sysdirs -xdev -type d \
  -exec chown root:root {} \; \
  -exec chmod 0755 {} \;

# Remove unneeded command
find $sysdirs -xdev \( \
  -name od -o \
  -name strings -o \
  -name su \
  -name sudo \
  -name df \
  -name du \
  -name netstat \
  -name ping \
  -name traceroute \
  -name nc \
  -name curl \
  -name wget \
  \) -delete