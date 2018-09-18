#!/bin/bash

CONTAINERS=$(/snap/bin/lxc list -c n --format csv)

containerInfo () {
local STAT=$(/snap/bin/lxc list $CONTAINER -c s --format csv | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}')
local IP4=$(/snap/bin/lxc list $CONTAINER -c 4 --format csv)
#local MUSE=$(/snap/bin/lxc info $CONTAINER | awk '/Memory \(current\)/ {print $3}')
local DUSE=$(/snap/bin/lxc exec $CONTAINER -- du -shx / | awk '{print $1}')

    echo "<tr>"
    echo "<td>$CONTAINER</td>"
    echo "<td>$STAT</td>"
    echo "<td>$IP4</td>"
    #echo "<td>$MUSE</td>"
    echo "<td>$DUSE</td>"
    echo "</tr>"

}

for CONTAINER in $CONTAINERS
do
san=$(echo $CONTAINER | sed 's/[^a-zA-Z0-9]//g')
containerInfo > /tmp/$san &
done
wait

echo "<section id='containers'>"
echo "<table>"
echo "<thead>"
echo "<tr>"
echo "<th>Name</th>"
echo "<th>Status</th>"
echo "<th>IP</th>"
#echo "<th>Memory</th>"
echo "<th>Disk</th>"
echo "</tr>"
echo "</thead>"
echo "<tbody>"

for CONTAINER in $CONTAINERS
do
san=$(echo $CONTAINER | sed 's/[^a-zA-Z0-9]//g')
cat /tmp/$san
rm /tmp/$san
done
echo "</tbody>"
echo "</table>"
echo "</section>"
