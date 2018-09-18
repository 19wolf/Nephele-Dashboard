<!DOCTYPE html>
<html lang='en'>
<head>
<meta charset='utf-8'>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Nephele</title>
<link rel='stylesheet' href='index.css'>
<link rel="stylesheet" href="https://cdn.rawgit.com/mblode/marx/master/css/marx.min.css">
</head>
<body>
<header>
<h1>Nephele</h1>
</header>
<nav>
<a href='http://192.168.2.1:32400/web/' target='_blank'>Plex</a>
<a href='http://192.168.2.1:8181/' target='_blank'>Tautulli</a>
<a href='http://nephele.ericwolf.me/transmission/web/' target='_blank'>Transmission</a>
<a href='http://nephele.ericwolf.me/sonarr' target='_blank'>Sonarr</a>
<a href='http://nephele.ericwolf.me/radarr' target='_blank'>Radarr</a>
<a href='http://nephele.ericwolf.me/lidarr' target='_blank'>Lidarr</a>
<a href='http://nephele.ericwolf.me/jackett' target='_blank'>Jackett</a>
<a href='http://nephele.ericwolf.me/lizard' target='_blank'>LizardFS</a>
</nav>
<?php
include 'stats.php';
include 'containers.php';
include 'disks.php';
include 'pools.php';
include 'changes.php';
 ?>
<footer>
<p>Eric Wolf</p>
</footer>
</body>
</html>
