#!/bin/bash

##### Backup compute scripts and source code to cloud. #####

TARGET_DIR="/work/slater_lab"
BACKUP_DIR="/home/ty.werbicki/Slater_Lab"
OMIT_DIRS=("anaconda3" "software" "src")

# Make temporary directory to store files.
mkdir -pv "${BACKUP_DIR}/slater_lab_backup_tmp"

cd "${BACKUP_DIR}/slater_lab_backup_tmp"

for dir in $(ls "$TARGET_DIR")
do
    # Don't scan a directory if it is to be omitted.
    [[ $( echo ${OMIT_DIRS[@]} | grep -Fw "$dir" | wc -l ) -eq 1 ]] && continue

    # Log directory.
    echo "Searching ${TARGET_DIR}/${dir}"

    # Search for and copy any .sh, .py, .slurm, or .R files.
    find "${TARGET_DIR}/${dir}" \( -name "*.sh" -o -name "*.py" -o -name "*.slurm" -o -name "*.R" \) \
        -exec cp "{}" . \;

done

# Compress directory.
# c = create new archive.
# z = filter the archive through gzip.
# f = use archive file.
tar czf "${BACKUP_DIR}/slater_lab_backup.tar.gz" *

# Remove temporary dir.
rm -rf "${BACKUP_DIR}/slater_lab_backup_tmp"

# How to extract the backup (slater_lab_backup.tar.gz):
#mkdir -p <path/to/extract_dir> 
#tar -xf slater_lab_backup.tar.gz -C <path/to/extract_dir>
