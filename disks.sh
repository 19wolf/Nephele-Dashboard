#!/bin/bash

SCSI=$(mktemp) ##Needed for Name
/usr/bin/lsscsi | rev | awk '{print $1 " " $3}' | rev > $SCSI ##Needed for Name

DISKS=$(awk '{print $2}' $SCSI)

diskInfo () {

SMART=$(mktemp $DISKXXX)
/usr/sbin/smartctl -d sat -a $DISK > $SMART
local NAME=$(awk "/$(echo $DISK | cut -c 6-)/"'{print $1}' $SCSI) ## <-- This is why
local TEMP=$(awk '$1=="194" {print $10}' $SMART)
local REALLOC=$(awk '$1=="5" {print $10}' $SMART)
local HEALTH=$(awk '/health/ {print $NF}' $SMART)

echo "<tr>"
echo "<td>$NAME</td>"
echo "<td>$TEMP</td>"
echo "<td>$REALLOC</td>"
echo "<td>$HEALTH</td>"
echo "</tr>"

rm $SMART
}

for DISK in $DISKS
do
san=$(echo $DISK | sed 's/[^a-zA-Z0-9]//g')
diskInfo > /tmp/$san &
done
wait

echo "<section id='disks'>"
echo "<table>"
echo "<thead>"
echo "<tr>"
echo "<th>Disk</th>"
echo "<th>Temperature</th>"
echo "<th>Reallocated Sectors</th>"
echo "<th>Health</th>"
echo "</tr>"
echo "</thead>"
echo "<tbody>"
for DISK in $DISKS
do
san=$(echo $DISK | sed 's/[^a-zA-Z0-9]//g')
cat /tmp/$san
rm /tmp/$san
done
echo "</tbody>"
echo "</table>"
echo "</section>"

rm $SCSI
