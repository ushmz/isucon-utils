#!/bin/bash

deco() {
    printf "\n[\033[00;34m$1\033[0m]\n"
}

# Distribution
deco "Distribution"
cat /etc/issue

# CPU
deco "CPU"
cat /proc/cpuinfo | grep -E 'cpu cores|siblings' | sort | uniq

# Memory
# cat /proc/meminfo
deco "Memory"
free -h

# Disk
deco "Disk"
df -h
