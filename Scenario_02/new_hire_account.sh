#!/bin/bash

######################################
# New Hire User Creation Script
# Usage:
#   sudo ./create_new_hire.sh <username> "<Full Name>"
#
# Example:
#     sudo ./create_new_hire john "John Tom"
###########################

# A. Make sure the script run as a root
if [ "$EUID" -ne 0 ];then
   echo "ERROR: Please run this script with sudo..."
   echo 'Example: sudo ./create_new_hire john "John Tom"'
   exit 1
fi
# B. Check arguments
if [ "$#" -ne 2 ]; then
   echo "Usage $0 <username>\"Full Name\""
   echo "Example: sudo $0 John \"John Tom\""
   exit 1
fi

# Store the information

USERNAME="$1"
FULLNAME="$2"
GROUP='developers'
SHELL='/bin/bash'
MAX_DAYS=90
WARNING_DAYS=7

echo "======================================="
echo "NEW HIRE ACCOUNT CREATION "
echo "======================================="
echo ""
echo ""
echo "Username: $USERNAME"
echo "Full Name: $FULLNAME"
echo "GROUP: $GROUP"
echo  "shell: $SHELL"
echo""

# D. Check if developers group exists

if getent group "$GROUP" > /dev/null 2>&1; then
        echo "[OK] Group '$GROUP' already exists."
else
        echo "[INFO] Creating group '$GROUP'"
        groupadd "$GROUP"
        if [ $? -eq 0 ]; then
             echo "[OK] Group '$GROUP' created."
        else
             echo " [ERROR] could not create group '$GROUP'"
             exit 1
         fi
fi

# E. Check if user already exists
if id "$USERNAME" > /dev/null 2>&1; then
        echo "[ERROR] User '$USERNAME' already exists."
        exit 1
fi

# F. Create New User
useradd -m -c "$FULLNAME" -s "$SHELL" -g "$GROUP" "$USERNAME"

if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to create '$USERNAME'"
        exit 1
fi

# F. Configure password aging
echo "[INFO] Configuring password againg...."
chage -M "$MAX_DAYS" -W "$WARNING_DAYS" "$USERNAME"

if [ $? -ne 0 ];then
        echo "[ERROR] Failed to configure password againg..."
        exit 1
fi
echo "[OK] Password maximum age: $MAX_DAYS days"
echo "[OK] Password warning: $WARNING_DAYS days"

# G. Set the user's password
echo ""
echo " ================================================="
echo "Set a password for '$USERNAME'"
echo "================================================="

# H. Display account information

echo ""
echo "================================================="
echo "ACCOUNT CREATED SUCCESSFULLY"
echo "================================================="
echo ""
echo "Username       :$USERNAME"
echo "Full Name      :$FULLNAME"
echo "Home Directory :/home/$USERNAME"
echo "Shell          :$SHELL"
echo "Group          :$GROUP"
echo "Password Max Age  :$MAX_DAYS days"
echo "Pawword Warning   :$WARNING_DAYS days"
echo ""

# I.Verification

echo " --------User Information------"
id "$USERNAME"

echo ""
echo "-------Password Aging------"
chage -l "$USERNAME"

echo ""
echo "======================================"
echo "New Hire completed for $FULLNAME."
echo ""
