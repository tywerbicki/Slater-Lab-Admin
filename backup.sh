#!/bin/bash

##### Backup compute scripts and source code to cloud. #####

TARGET_DIR="/work/slater_lab"
BACKUP_DESTINATION="/home/ty.werbicki/Slater_Lab"
OMIT_DIRS=("anaconda3" "software" "src")

# Make temporary directory to store files.
mkdir -pv "${BACKUP_DESTINATION}/slater_lab_backup_tmp"
cd "$TARGET_DIR"

for dir in $( ls )
do
    # Don't scan a directory if it is to be omitted.
    [[ $( echo ${OMIT_DIRS[@]} | grep -Fw "$dir" | wc -l ) -eq 1 ]] && continue

    # Log directory.
    echo "Searching ${TARGET_DIR}/${dir}"

    # Search for any of the following file extensions and store in text file.
    find "$dir" \( -name "*.sh" -o -name "*.py" -o -name "*.slurm" -o -name "*.R" -o -name "*.c" -o -name "*.cpp" \) \
        > file_names.txt

    # Copy the files of interest into the temporary backup directory.
    # This method will preserve the directory structure.
    while read file_name; do
        dir=$( dirname "$file_name" )
        mkdir -p "${BACKUP_DESTINATION}/slater_lab_backup_tmp/${dir}"
        cp "$file_name" "${BACKUP_DESTINATION}/slater_lab_backup_tmp/${file_name}" 
    done < file_names.txt

done

rm file_names.txt
cd "${BACKUP_DESTINATION}/slater_lab_backup_tmp"

# Compress directory.
# c = create new archive.
# z = filter the archive through gzip.
# f = use archive file.
tar czf "${BACKUP_DESTINATION}/slater_lab_backup.tar.gz" *

# Remove temporary directory.
cd "$HOME"
rm -rf "${BACKUP_DESTINATION}/slater_lab_backup_tmp"

# How to extract the backup (slater_lab_backup.tar.gz):
#mkdir -p <path/to/extract_dir> 
#tar -xf slater_lab_backup.tar.gz -C <path/to/extract_dir>
