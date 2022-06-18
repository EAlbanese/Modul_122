#!/bin/bash
cwd=`pwd`        # current working directory
cd `dirname $0`    # change to the directory where the script is located
BINDIR=`pwd`    # BINDIR: the directory where the script is located
cd $cwd        # return to the working directory
BASENAME=`basename $0`    # Set the script name (without path to it)
TMPDIR=/tmp/$BASENAME.$$    # Set a temporary directory if needed
ETCDIR=$BINDIR/../etc        # ETCDIR is the config directory

#Jetzt sollte als erstes das/die Konfigfile(s) eingelesen werden:
# .    # run config file “Scriptname”.env

if [ -s $ETCDIR/user.txt ];
    then 
    cat $ETCDIR/user.txt |grep -v '^#'|grep -v '^$' | while read username firstname name groupname ; do
        if [ -z "$username" ] | [ -z "$firstname" ] | [ -z "$name" ] | [ -z "$groupname" ]; then  
            echo "Falsche eingaben"
        else
            if [ $(getent group $groupname) ]; 
            then
                echo -e $groupname "used for" $username "\n---------------------------------"
            else
                groupadd $groupname
            fi
            
            if id $username &>/dev/null 2<&1; 
            then
                echo ${YELLOW}"WARNING:" ${WHITE}"THIS USER ALREADY EXISTS"
            else
                useradd -m -G $groupname $username -p $DEFAULTPASSWORD
                passwd -e $username
            fi

            DIR="/home/users/$username/"
            if [ -d "$DIR" ]; then
                echo "${DIR} already exist"
            else
                echo "Error: ${DIR} not found. Can not continue."
                exit 1
            fi

        fi
    done
    
else
    echo "File is empty"
fi
