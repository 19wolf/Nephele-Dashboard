#!/bin/bash

#Gather data

##Containers
for i in $(lxc list -c n --format csv); 
do
	myContainers=("${myContainers[@]}" "$i");
done

for i in ${!myContainers[@]};
do 
	lxc info ${myContainers[$i]} > /tmp/lxd_info.tmp;
	STAT[$i]=$(cat /tmp/lxd_info.tmp | awk '/Status/ {print $2}');
	MEMUSAGE[$i]=$(cat /tmp/lxd_info.tmp | awk '/Memory \(current\)/ {print $3}');
    DISKUSE[$i]=$(lxc exec ${myContainers[$i]} -- du -shx / | awk '{print $1}');
done

##Disks
for dev in $(ls /dev/disk/by-id/ | awk '/ata/ && !/part/');
do
	myDevices=("${myDevices[@]}" "$dev");
done

for i in ${!myDevices[@]};
do
  /usr/sbin/smartctl -a /dev/disk/by-id/${myDevices[$i]} > /tmp/smart.tmp;
  TEMP[$i]=$(cat /tmp/smart.tmp | awk '$1=="194" {print $10}');
  ERROR[$i]=$(cat /tmp/smart.tmp | awk '$1=="1" {print $10}');
  HEALTH[$i]=$(cat /tmp/smart.tmp | awk '/result/ {print $NF}');
  SERIAL[$i]=$(cat /tmp/smart.tmp | awk '/Serial Number/ {print $3}');
  REALLOC[$i]=$(cat /tmp/smart.tmp | awk '$1=="5" {print $10}');
done

##Disks
for path in / /boot /data
do
	myPaths=("${myPaths[@]}" "$path")
done

for i in ${!myPaths[@]}
do
	myUsed[$i]=$(df -h ${myPaths[$i]} | awk '/\// {print $3}')
	myAvail[$i]=$(df -h ${myPaths[$i]} | awk '/\// {print $4}')
done

##General
myuptime=$(uptime -p | cut -d " " -f 2,3,4,5,6,7);
mydate=$(date);
memused=$(free -h | awk '/Mem/ {print $3}');

#Output
echo "<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\">
    <title>Nephele</title>
    <link rel=\"stylesheet\" href=\"index.css\">
    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css\">
  </head>
  <body>
    <header>
      <h1>Nephele</h1>
    </header>
    <nav>
      <a href=\"/plex/\" target=\"_blank\">Plex</a>
      <a href=\"/plexpy/\" target=\"_blank\">PlexPy</a>
      <a href=\"/resilio/\" target=\"_blank\">Resilio</a>
      <a href=\"/transmission/web/\" target=\"_blank\">Transmission</a>
      <a href=\"/sonarr/\" target=\"_blank\">Sonarr</a>
      <a href=\"/radarr/\" target=\"_blank\">Radarr</a>
      <a href=\"/jackett/\" target=\"_blank\">Jackett</a>
    </nav>";

#General

echo "    <section id=\"stats\">
      <p>Uptime: "$myuptime"</p>
      <p>Last run: "$mydate"</p>
      <p>Used RAM: "$memused"</p>
    </section>";

#Containers
echo "    <section id=\"containers\">
      <table>
        <tr>
          <th>Name</th>
          <th>Status</th>
          <th>Ram Usage</th>
          <th>Disk Usage</th>
        </tr>";

for i in ${!myContainers[@]};
do
    echo "        <tr>
          <td>"${myContainers[$i]}"</td>
          <td>"${STAT[$i]}"</td>
          <td>"${MEMUSAGE[$i]}"</td>
          <td>"${DISKUSE[$i]}"</td>
        </tr>";
done

echo "      </table>
    </section>";

#Disks
echo "    <section id=\"disks\">
      <table>
        <tr>
          <th>Disk</th>
          <th>Temperature</th>
          <th>Read errors</th>
          <th>Reallocated Sectors</th>
          <th>Health</th>
        </tr>";

for i in ${!myDevices[@]};
do
  echo "        <tr>
          <td>"${SERIAL[$i]}"</td>
          <td>"${TEMP[$i]}"</td>
          <td>"${ERROR[$i]}"</td>
          <td>"${REALLOC[$i]}"</td>
          <td>"${HEALTH[$i]}"</td>
        </tr>";
done

echo "      </table>
    </section>";

#Data Usage
echo "    <section id=\"pools\">
      <table>
        <tr>
          <th>Path</th>
          <th>Used</th>
          <th>Free</th>
        </tr>";

for i in ${!myPaths[@]}
do
  echo "        <tr>
          <td>"${myPaths[$i]}"</td>
          <td>"${myUsed[$i]}"</td>
          <td>"${myAvail[$i]}"</td>
        </tr>";
done
echo "      </table>
    </section>";

echo "
    <footer>Eric Wolf</footer>
  </body>
</html>
";
