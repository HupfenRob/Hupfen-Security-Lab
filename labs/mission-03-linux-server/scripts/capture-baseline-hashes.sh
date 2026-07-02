#!/bin/bash

############################################################
# Script: capture-baseline-hashes.sh
#
# Mission:
# Mission 3 - Linux Server
#
# Purpose:
# Capture baseline SHA-256 hashes for key Linux system files to support
# integrity monitoring and future comparison.
############################################################

sudo sha256sum /etc/passwd /etc/shadow /etc/group /etc/sudoers /etc/ssh/sshd_config /etc/issue.net > ~/baseline_hashes.txt
