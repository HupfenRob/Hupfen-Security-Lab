############################################################
# Script: initialize-admin-password.ps1
#
# Mission:
# Mission 2.5 - Strong Windows VM
#
# Purpose:
# Generate a random password, configure the hidden
# Administrator account, and store the password
# in a protected location.
############################################################   
   
# Generate a strong random password

$Password = [System.Guid]::NewGuid().ToString() + [System.Guid]::NewGuid().ToString().Substring(0,8)

# Set the password for the hidden Admin account

net user Admin $Password

# Define the path where the password will be stored

$LogPath = "C:\SecureAdminPassword\admin_password.txt"

# Create the directory if it does not already exist

if (!(Test-Path "C:\SecureAdminPassword")) {
    New-Item -ItemType Directory -Path "C:\SecureAdminPassword" | Out-Null
}

# Write password to file (SYSTEM-only readable)

$Password | Out-File $LogPath
