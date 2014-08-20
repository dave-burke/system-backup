#!/bin/bash

DEST=servy::/mnt/media/backup/systems/$(uname -n)

START=$(date +%s)
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
	--exclude='/.snapshots/*' \
	--preserve-numerical-ids \
	--verbosity 5 \
	/ $DEST 
FINISH=$(date +%s)
echo "Backup completed in $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"

echo "Verifying..."
rdiff-backup --verify $DEST

echo "Cleaning up increments older than one month..."
rdiff-backup --remove-older-than 1M $DEST
