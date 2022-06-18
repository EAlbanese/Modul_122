#!/usr/bin/env bash
cwd=`pwd`		# current working directory
cd `dirname $0`	# change to the directory where the script is located
BINDIR=`pwd`	# BINDIR: the directory where the script is located
cd $cwd		# return to the working directory
BASENAME=`basename $0`	# Set the script name (without path to it)
TMPDIR=/tmp/$BASENAME.$$	# Set a temporary directory if needed
ETCDIR=$BINDIR/../etc		# ETCDIR is the config directory
DEFAULTPASSWORD=${1?Error: no default password given}
FILE_NAME=${2?Error: no file name given}
echo "create new users from" $FILE_NAME

#importing colors
RESTORE=$(echo -en '\001\033[0m\002')
YELLOW=$(echo -en '\001\033[00;33m\002')
GREEN=$(echo -en '\001\033[00;32m\002')
RED=$(echo -en '\001\033[00;31m\002')
WHITE=$(echo -en '\001\033[01;37m\002')
if [ -s ../etc/user.txt ];
  then 
  cat ../etc/$FILE_NAME|grep -v '^#'|grep -v '^$'|while read user firstname name group; do
    if [ -z "$user" ] | [ -z "$firstname" ] | [ -z "$name" ]; then

      if [ $(getent group $groupname) ]; 
      then
        echo -e $groupname "used for" $username "\n---------------------------------"
      else
        echo -e ${YELLOW}"WARNING:" ${WHITE}"GROUP" $groupname "DOES NOT EXIST YET\nCreating group" $groupname "..."
        groupadd $groupname
        echo -e "group has been sucessfully created\n---------------------------------"
      fi

      if id $username &>/dev/null 2<&1; 
      then
        echo ${YELLOW}"WARNING:" ${WHITE}"THIS USER ALREADY EXISTS"
        existing_username=$username
        echo "---------------------------------"
      else
        echo $username "is being created"
        useradd -m -G $groupname $username -p $DEFAULTPASSWORD
        passwd -e $username
        echo -e "user created!\n---------------------------------"
        existing_username=$username
      fi

      echo "File structure is beeing created"
      cd /
      mkdir -p home/$username/$groupname/whatever/{test,anotherTest}
      echo -e ${GREEN}"User has been created successfully"${WHITE}"\n----------------------------------"
  else echo "Not NULL";  
        fi 
  done
  echo "All users have been created"
else
    echo "File is empty"
fi