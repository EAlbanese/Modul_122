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
userList=()
groupList=()

echo ""
echo "USERS"
echo ""

if [ -s ../etc/user.txt ];
    then 
    cat ../etc/user.txt |grep -v '^#'|grep -v '^$' | while read user firstname name group ; do
        userList+=($user)
        userList+=($firstname)
        userList+=($name)
        userList+=($group)
        echo ${userList[@]}
        echo "---------------------"    
    done
    
else
    echo "File is empty"
fi

echo ""
echo "GROUP"
echo ""

if [ -s ../etc/group.txt ];
    then 
    cat ../etc/group.txt |grep -v '^#'|grep -v '^$' | while read user ; do
        echo groupname: $user
        echo "---------------------"
    done
else
    echo "File is empty"
fi