#!/bin/sh
value=`cat ../etc/user.txt`
echo "$value"
x=julia
[[ $value =~ (^|[[:space:]])$x($|[[:space:]]) ]] && echo 'yes' || echo 'no'
 
#log=log_file.txt
 
# create log file or overrite if already present
#printf "Log File - " > $log
 
# append date to log file
#date >> $log
 
x=$(( 3 + 1 ))
# append some data to log file
#echo value of x is $x >> $log

. ../etc/backup.conf

log=log_file.txt
printf "Log File - " > $log
x=date +%H:%M
date +%H:%M >> $log
sleep 10
date +%H:%M >> $log
date >> $log
date >> $log

echo $EXCLUDE 
echo $SOURCE 
echo $BACKUP_DIR 
echo $ROTATE_DIR