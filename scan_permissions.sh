#!/bin/bash

TARGET_DIR="/work/slater_lab"
DEPOSIT_DIR="/home/ty.werbicki/Slater_Lab"
MAX_DEPTH="4"
USERS=("ty.werbicki" "kylie.hornaday" "eilidh.wood" "andrew.chen1" "matthew.newton")
OMIT_DIRS=("anaconda3" "software" "src")

# If there are previous reports, remove them.
[[ -f "$DEPOSIT_DIR/wrong_group.txt" ]] && rm "$DEPOSIT_DIR/wrong_group.txt"
[[ -f "$DEPOSIT_DIR/bad_permissions.txt" ]] && rm "$DEPOSIT_DIR/bad_permissions.txt"
[[ -f "$DEPOSIT_DIR/report.txt" ]] && rm "$DEPOSIT_DIR/report.txt"

for dir in $(ls "$TARGET_DIR")
do  
    # Don't scan a directory if it is to be omitted.
    [[ $( echo ${OMIT_DIRS[@]} | grep -Fw ${dir} | wc -l ) -eq 1 ]] && continue

    # Log directory.
    echo "Scanning ${TARGET_DIR}/${dir}"

    # Check for any file that isn't assigned to the slater_lab group.
    find "${TARGET_DIR}/${dir}" -maxdepth $MAX_DEPTH ! -group slater_lab >> $DEPOSIT_DIR/wrong_group.txt

    # Check for any file that 'other users' can access.
    find "${TARGET_DIR}/${dir}" -maxdepth $MAX_DEPTH -perm /o+r,o+w,o+x >> $DEPOSIT_DIR/bad_permissions.txt

    # Uncomment lines below if you have appropriate permissions.

    # Change group of all files to slater_lab.
    #find "${TARGET_DIR}/${dir}" ! -group slater_lab -exec chgrp slater_lab {} +

    # Revoke 'other users' access to all files.
    #find "${TARGET_DIR}/${dir}" -perm /o+r,o+w,o+x -exec chmod o-rwx {} +
    
done

for user in ${USERS[@]}
do
    # Record user.
    echo $user >> $DEPOSIT_DIR/report.txt 
    
    # Record number of "wrong groups" for $user.
    echo "Wrong groups:" >> $DEPOSIT_DIR/report.txt
    cat $DEPOSIT_DIR/wrong_group.txt | xargs stat -c %U | grep "$user" | wc -l \
        >> $DEPOSIT_DIR/report.txt

    # Record number of "wrong permissions" for $user.
    echo "Wrong permissions:" >> $DEPOSIT_DIR/report.txt
    cat $DEPOSIT_DIR/bad_permissions.txt | xargs stat -c %U | grep "$user" | wc -l \
        >> $DEPOSIT_DIR/report.txt

    # Add newline.
    echo "" >> $DEPOSIT_DIR/report.txt

done