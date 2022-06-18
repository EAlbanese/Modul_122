#!/bin/bash
cwd=`pwd`        # current working directory
cd `dirname $0`    # change to the directory where the script is located
BINDIR=`pwd`    # BINDIR: the directory where the script is located
cd $cwd        # return to the working directory
BASENAME=`basename $0`    # Set the script name (without path to it)
TMPDIR=/tmp/$BASENAME.$$    # Set a temporary directory if needed
ETCDIR=$BINDIR/../etc        # ETCDIR is the config directory

. /path/to/some.config

# What to backup. 
backup_files="/home/users"

# Where to backup to.
dest="/home/backup"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest