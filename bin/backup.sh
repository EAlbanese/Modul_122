#!/bin/bash
TIMESTAMP='timestamp.dat'
DATE=$(date +%Y-%m-%d-%H%M%S)

. ../etc/backup.conf
BACKUP_DIR=$BACKUP_DIR 
ROTATE_DIR=$ROTATE_DIR
SOURCE=$SOURCE
EXCLUDE=$EXCLUDE

cd /
mkdir -p ${BACKUP_DIR}
set -- ${BACKUP_DIR}/backup-??.tar.gz
lastname=${!#}
backupnr=${lastname##*backup-}
backupnr=${backupnr%%.*}
backupnr=${backupnr//\?/0}
backupnr=$[10#${backupnr}]

if [ “$[backupnr++]” -ge $DELETE_BACKUP_TIME ]; then
  mkdir -p ${ROTATE_DIR}/${DATE}
  mv ${BACKUP_DIR}/b* ${ROTATE_DIR}/${DATE}
  mv ${BACKUP_DIR}/t* ${ROTATE_DIR}/${DATE}
  backupnr=1
fi

backupnr=0${backupnr}
backupnr=${backupnr: -2}
filename=backup-${backupnr}.tar.gz
tar -cpzf ${BACKUP_DIR}/${filename} -g ${BACKUP_DIR}/${TIMESTAMP} -X $EXCLUDE ${SOURCE}