#!/bin/bash
cwd=`pwd`        # current working directory
cd `dirname $0`    # change to the directory where the script is located
BINDIR=`pwd`    # BINDIR: the directory where the script is located
cd $cwd        # return to the working directory
BASENAME=`basename $0`    # Set the script name (without path to it)
TMPDIR=/tmp/$BASENAME.$$    # Set a temporary directory if needed
ETCDIR=$BINDIR/../etc        # ETCDIR is the config directory

#Default Passwort aus userConfig:
. ../etc/userConfig.conf

log=log_file.txt
printf "Log File - " > $log
date >> $log

backupGroups=`cat ../etc/user.env`
 

if [ -s ../etc/user.env ];
    then 
    cat ../etc/user.env |grep -v '^#'|grep -v '^$' | while read username firstname name groupname ; do
        if [ -z "$username" ] | [ -z "$firstname" ] | [ -z "$name" ] | [ -z "$groupname" ]; then  
            echo "invalid entry" >> $log
        else
            echo $groupname
            if [ $(getent group $groupname) ]; 
            then
                echo $username 'belongs to the' $groupname >> $log
            else
                echo 'New group with the group name:' $groupname 'is created' >> $log
                groupadd $groupname
                echo $groupname 'was created' >> $log
            fi

            [[ $backupGroups =~ (^|[[:space:]])$groupname($|[[:space:]]) ]] && echo 'Backups are made of the user' >> $log || echo 'No backups are made by the user' >> $log
            
            if id $username &>/dev/null 2<&1; 
            then
                echo 'This user already exists' >> $log
            else
                echo $username 'is being created' >> $log
                useradd -m -G $groupname $username -p $DEFAULT_PASSWORD
                passwd -e $username
                echo $username 'has been created' >> $log
            fi

            echo 'user directory' >> $log
            DIR="/home/users/$username/{$groupname,privat}"
            if [ -d "$DIR" ]; then
                echo $DIR 'already exist' >> $log
            else
                echo 'user directory is being created' >> $log
                mkdir -p /home/$username/{$groupname,privat}
                echo "User has been created successfully" >> $log
                exit 1
            fi
        fi
    done
    echo 'All users have been created' >> $log
else
    echo "File is empty" >> $log
fi
