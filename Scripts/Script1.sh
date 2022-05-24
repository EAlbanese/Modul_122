#!/bin/bash
cwd=`pwd`		# aktuelles Arbeitsverzeichnis
cd `dirname $0`	# in das Verzeichnis wechseln, in dem sich das Skript befindet
BINDIR=`pwd`	# BINDIR: das Verzeichnis, in dem sich das Skript befindet
cd $cwd		# zurück zum Arbeitsverzeichnis
BASENAME=`basename $0`	# Skriptnamen festlegen (ohne Pfadangabe)
TMPDIR=/tmp/$BASENAME.$$	# bei Bedarf ein temporäres Verzeichnis festlegen 
ETCDIR=$BINDIR/../etc		# ETCDIR ist das Konfigurationsverzeichnis
USERFORCREATEUSERSCRIPTPATH=$1 # Pfad des Dateiverzeichnisses erstellten users.

. ../etc/backup.env.bash	# Konfigurationsdatei "“Scriptname”".env ausführen

IFS=$'\r\n' GLOBIGNORE='*' command eval  'groups=($(cat $Gruppendatei))'
groupssafed=( $(cut -d: -f1,3 /etc/group | tr '\n' ' ') )

while IFS=',' read field1 field2 field3
do

	if [ ! "$field1" == "" ] && [ ! "$field2" == "" ] && [ ! "$field3" == "" ] 
    then
		# do wenn "field1" nicht leer ist

        if ! grep -q $field1 /etc/passwd
        then
            if [[ " ${groups[*]} " =~ " ${field2} " ]]; 
            then
                # tun, wenn Array Wert enthält
                echo "Gruppe $field2 ist im Backup-File gespeichert."

            elif [[ ! " ${groups[*]} " =~ " ${field2} " ]];
            then
                # tun, wenn das Array keinen Wert enthält
             echo "Gruppe $field2 ist nicht im Backup-File gespeichert."

            fi
            
            if grep -q $field2 /etc/group
            then
                # tun, wenn die Gruppe existiert

                useradd -m -G $field2 $field1
                echo "User $field1 wurde erstellt und zur Gruppe $field2 hinzugefügt"
            else
                echo "Gruppe $field2 existiert nicht, User $field1 kann nicht erstellt werden!"
            fi
        else
            echo "User $field1 existiert schon. Kein User wird erstellt"
        fi
	else
		echo "$field1, $field2, $field3 sind ungültig"
    fi
		

done < $1