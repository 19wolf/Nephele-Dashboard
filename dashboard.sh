#!/bin/bash

#HTML Header
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

#Stats
myuptime=$(uptime -p | cut -d " " -f 2,3,4,5,6,7);
mydate=$(date);
memtotal=$(free -h | awk '/Mem/ {print $2}');
memused=$(free -h | awk '/Mem/ {print $3}');

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
for containers in $(lxc list -c n | grep -v '-' | awk '!/NAME/ {print $2}')
do
  for container in $containers
  do
    lxc info $container > /tmp/lxd_info.tmp;
    STAT=$(cat /tmp/lxd_info.tmp | awk '/Status/ {print $2}');
    MEMUSAGE=$(cat /tmp/lxd_info.tmp | awk '/Memory \(current\)/ {print $3}');
    DISKUSE=$(lxc exec $container -- du -shx / | awk '{print $1}');

    echo "        <tr>
          <td>"$container"</td>
          <td>"$STAT"</td>
          <td>"$MEMUSAGE"</td>
          <td>"$DISKUSE"</td>
        </tr>";

  done
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
for dev in $(ls /dev/disk/by-id/ | awk '/ata/ && !/part/')
do
  /usr/sbin/smartctl -a /dev/disk/by-id/$dev > /tmp/smart.tmp;
  TEMP=$(cat /tmp/smart.tmp | awk '$1=="194" {print $10}');
  ERROR=$(cat /tmp/smart.tmp | awk '$1=="1" {print $10}');
  HEALTH=$(cat /tmp/smart.tmp | awk '/result/ {print $NF}');
  SERIAL=$(cat /tmp/smart.tmp | awk '/Serial Number/ {print $3}');
  REALLOC=$(cat /tmp/smart.tmp | awk '$1=="5" {print $10}');

  echo "        <tr>
          <td>"$SERIAL"</td>
          <td>"$TEMP"</td>
          <td>"$ERROR"</td>
          <td>"$REALLOC"</td>
          <td>"$HEALTH"</td>
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
for path in / /boot /data
do
  used=$(df -h $path | awk '/\// {print $3}');
  avail=$(df -h $path | awk '/\// {print $4}');

  echo "        <tr>
          <td>"$path"</td>
          <td>"$used"</td>
          <td>"$avail"</td>
        </tr>";
done
echo "      </table>
    </section>";

echo "
    <footer>Eric Wolf</footer>
  </body>
</html>
";
