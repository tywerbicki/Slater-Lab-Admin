#!/bin/bash

DEPOSIT_DIR="/home/ty.werbicki/Slater_Lab"
USERS=("ty.werbicki" "kylie.hornaday" "eilidh.wood" "andrew.chen1" "matthew.newton")

# If there is a previous jobs report, remove it.
[[ -f "${DEPOSIT_DIR}/jobs_report.txt" ]] && rm "${DEPOSIT_DIR}/jobs_report.txt"

for user in ${USERS[@]}
do
    # Record user.
    echo "$user" >> "${DEPOSIT_DIR}/jobs_report.txt" 

    # Record number of pending jobs for $user.
    echo "Pending jobs:" >> "${DEPOSIT_DIR}/jobs_report.txt"
    squeue -u "$user" | grep -w "PD" | wc -l >> "${DEPOSIT_DIR}/jobs_report.txt"

    # Record number of running jobs for $user.
    echo "Running jobs:" >> "${DEPOSIT_DIR}/jobs_report.txt"
    squeue -u "$user" | grep -w "R" | wc -l >> "${DEPOSIT_DIR}/jobs_report.txt"

    # Add newline.
    echo "" >> "${DEPOSIT_DIR}/jobs_report.txt"

done