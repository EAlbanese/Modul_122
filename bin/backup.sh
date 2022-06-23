#!/bin/bash
cwd=$(pwd)		# current working directory
cd $(dirname $0)	# change to the directory where the script is located
BINDIR=$(pwd)	# BINDIR: the directory where the script is located
cd $cwd		# return to the working directory
BASENAME=$(basename $0)	# Set the script name (without path to it)
TMPDIR=/tmp/$BASENAME.$$	# Set a temporary directory if needed

. ../etc/backup.conf
BACKUP_DIR=$BACKUP_DIR
SOURCE=$SOURCE
EXCLUDE=$EXCLUDE
PRAEFIX=$PRAEFIX
file_limit=$MAX_BACKUP

log=log_file.txt
printf "Log File - " > $log
date >> $log

touch userlist.txt;
touch directions.txt;

cat ../etc/backupGroups.env | grep -v '^#' | grep -v '^$' | while read groupname; 
do
    if [ $(getent group $groupname)]; then
        LOGLEV=I
        username="$(getent group "$groupname" | cut -d: -f4)"
        echo "$username" >> userlist.txt;
    else
        LOGLEV=W
        echo "Group $groupname does not exist."
    fi
done

awk '!seen[$0]++' userlist.txt > usersList.txt;

cat usersList.txt | grep -v '^#' | grep -v '^$' | while read user
do
    if [ -d "/home/$user" ]; 
then
        cp -r "/home/$user" $TMPDIR
        awk -F: -v username=$user '$1==username /etc >> dirlist.txt'
    else
        LOGLEV=W
        echo "Directory /home/$user not found."
    fi
done



set -- ${BACKUP_DIR}/backup-??.tar.gz
backupnr=$(date +%s)
[ -z "$backupnr" ] && $backupnr='no-date'
filename=${PRAEFIX}-${backupnr}.tar.gz

echo "Backing up $SOURCE to $BACKUP_DIR/$filename"

tar -cvf $BACKUP_DIR/$filename -T directions.txt -X $EXCLUDE ${SOURCE}
find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type f -iname '*.tar.gz' -printf "%C+ %p\n" | sort -n | cut -d ' ' -f 2- | head -n -"$file_limit" | xargs -I{} rm "{}"
rm -r directions.txt usersList.txt;