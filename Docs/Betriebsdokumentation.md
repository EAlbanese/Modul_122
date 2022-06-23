# Betriebsdokumentation
[[_TOC_]]
## Einführungstext 

### Erstes Skript: Neuer User erstellen
Mit Hilfe einer Userliste werden neue Unix-User erstellt. In einem separaten File können verschiedene Konfigurationen konfiguriert werden.

### Zweites Skript: backupm erstellen
Das Script macht ein Backup von den notierten Gruppen. In einem separaten File können dazu verschiedene Konfigurationen konfiguriert werden.

## Installationsanleitung für Administratoren

### Installation

TODO: Wie ist das Skript zu installieren. (z.B. apt-get install ... oder tar xvf .... oder ...)

Zuerst muss das Repository geclont werden: <br>
```
git clone https://github.com/EAlbanese/m122_praxisarbeit_Goudsmit_Albanese.git
```

### Konfiguration

## Script 1: Unix-user erstellen
Um das erste Script auszuführen, muss zuerst in den Ordner bin/ navigiert werden. 
Anschliessend kann das Script mit folgendem Befehl ausgeführt werden: <br>
```
sudo bash User.sh
```

## Script 2: Backup erstellen
Um das erste Script auszuführen, muss zuerst in den Ordner bin/ navigiert werden. 
Mit Hilfe von Corntab wird das Script jeden Morgen um 5 Uhr Montag um 19:00 ausgeführt. Nun kann das Script mit folgendem Befehl ausgeführt werden: <br>
```
0 19 * * mon <Pfad>/User.sh
```

## Bediensanleitung Benutzer

## Script 1: Unix-user erstellen
Das Script braucht ein Configfile sowie zwei ENV-Datei mit den Usern und Gruppen, von denen ein Backup gemacht werden.

Im Config-File (userConfig.conf) können folgende Parameter angepasst werden: <br>

- DEFAULT_PASSWORD='defaultPassword'

Im user.env wird die Liste der User angepasst. Das Format muss jedoch beibehalten werden.
´´´
&ltusername&gt &ltfirstname&gt &ltname&gt &ltgroupname&gt
´´´

Im backupGroups.env werden untereinander die Gruppen aufgelistet, von denen ein Backup gemacht werden sollten.

## Script 2: Backup erstellen
Das Script braucht ein Configfile sowie eine ENV-Datei mit Gruppen, von denen ein Backup gemacht werden.

Im Config-File (backup.conf) können folgende Parameter angepasst werden: <br>

- MAX_BACKUP=10
- EXCLUDE=--exclude=/home/linuxjg
- SOURCE=/home
- BACKUP_DIR=/home/backups
- PRAEFIX='backup''

Im backupGroups.env werden untereinander die Gruppen aufgelistet, von denen ein Backup gemacht werden sollten.
