#!/bin/bash
DIRS="/data/Media/Anime /data/Media/Television /data/Media/Movies /data/Media/Music /data/Media/Photos /data/Eric /data/Sarah /data/Steam /data/Fileshare"

fileInfo () {
local CHANGE=$(find $DIR -not -path '*/\.*' -type f -mtime -7 | wc -l)

echo "<tr>"
echo "<td>$DIR</td>"
echo "<td>$CHANGE</td>"
echo "</tr>"

return 0
}

for DIR in $DIRS
do
san=$(echo $DIR | sed 's/[^a-zA-Z0-9]//g')
fileInfo > /tmp/$san &
done
wait

echo "<section id='files'>"
echo "<table>"
echo "<thead>"
echo "<tr>"
echo "<th>Directory</td>"
echo "<th>Changes (7 days)</th>"
echo "</tr>"
echo "</thead>"
echo "<tbody>"
for DIR in $DIRS
do
san=$(echo $DIR | sed 's/[^a-zA-Z0-9]//g')
cat /tmp/$san
rm /tmp/$san
done
echo "</tbody>"
echo "</table>"
echo "</section>"
