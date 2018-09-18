<section id='stats'>
<?php
$time=shell_exec("date +%T");
$date=shell_exec("date +%A', '%B' '%d', '%Y");
$uptime=shell_exec("uptime -p | cut -d' ' -f 2-");
$ram=shell_exec("free -h | awk '/Mem/ {print $3}'");

echo "<p>$time<br/>";
echo "$date<br/>";
echo "Uptime: $uptime<br/>";
echo "Ram: $ram</p>";
?>
</section>
