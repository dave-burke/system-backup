#!/bin/bash

START=$(date +%s)

# $(uname -n) resolves to the hostname
DEST=servy::/mnt/media/backup/systems/$(uname -n)

# /dev, /proc, /sys, /tmp, /run, /var/cache, and /var/run, and /lost+found are dynamically created system directories that should not be backed up.
# /mnt and /media are excluded to avoid backing up external media (USB drives) and remote file shares.
# /.snapshots are btrfs snapshots.
# --preserve-numerical-ids allows the backup to move between systems with different usernames and still be restored.
# --verbosity 5 prints the names of files that changed.
rdiff-backup \
	--exclude='/dev/*' \
	--exclude='/proc/*' \
	--exclude='/sys/*' \
	--exclude='/tmp/*' \
	--exclude='/run/*' \
	--exclude='/mnt/*' \
	--exclude='/media/*' \
	--exclude='/lost+found' \
	--exclude='/var/cache/*' \
	--exclude='/var/run/*' \
	--exclude='/.snapshots/*' \
	--preserve-numerical-ids \
	--verbosity 5 \
	/ $DEST 

echo "Verifying..."
rdiff-backup --verify $DEST

echo "Cleaning up increments older than one month..."
rdiff-backup --remove-older-than 1M $DEST

FINISH=$(date +%s)
echo "Backup completed in $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"
