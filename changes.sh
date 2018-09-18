#!/bin/bash
DIRS=$(find /data/Media/ -maxdepth 1 -mindepth 1 -type d -not -path '*/\.*' && find /data/ -maxdepth 1 -mindepth 1 -type d -not -path '*/\.*' -not -path '/data/Media')

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
