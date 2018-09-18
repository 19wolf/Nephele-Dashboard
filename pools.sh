#!/bin/bash

POOLS=$(mount | awk '/btrfs/ || /mfs/ || /xfs/ {print $3}' | sort)

poolInfo() {
local DFH=$(mktemp)
local DFB=$(mktemp)
df -H $POOL | sort -k6 | grep -v Filesystem > $DFH
df $POOL | sort -k6 | grep -v Filesystem > $DFB

local NAME=$(awk '{print $6}' $DFH)
local USED=$(awk '{print $3}' $DFH)
local FREE=$(awk '{print $4}' $DFH)
local PCENTUSED=$(awk '{print $5}' $DFH)
local TOTAL=$(awk '{print $2}' $DFH)
local metertotal=$(awk '{print $2}' $DFB)
local meterused=$(awk '{print $3}' $DFB)
local meterhigh=$(awk '{printf "%.2f", $2 * .9}' $DFB)
local meterlow=$(awk '{printf "%.2f", $2 * .75}' $DFB)

echo "<tr>"
echo "<td>$NAME</td>"
echo "<td><meter max='$metertotal' value='$meterused' high='$meterhigh' low='$meterlow' optimum='0' min='0'>$USED</meter></td>"
echo "<td>$FREE</td>"
echo "</tr>"

rm $DFH
rm $DFB
}

for POOL in $POOLS
do
san=$(echo "$POOL-1" | sed 's/[^a-zA-Z0-9]//g')
poolInfo > /tmp/$san &
done
wait

echo "<section id='pools'>"
echo "<table>"
echo "<thead>"
echo "<tr>"
echo "<th>Path</th>"
echo "<th>Usage</th>"
echo "<th>Free</th>"
echo "</tr>"
echo "</thead>"
echo "<tbody>"
for POOL in $POOLS
do
san=$(echo "$POOL-1" | sed 's/[^a-zA-Z0-9]//g')
cat /tmp/$san;
rm /tmp/$san
done
echo "</tbody>"
echo "</table>"
echo "</section>"
