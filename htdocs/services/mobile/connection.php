<?php
/**
 * [$site_config FROM RUOPEN: mobile/connection.php]
 * @var [<description>]
 */
$site_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.prd",true);
$servername = $site_config['MySQL']['Hostname'];
$username = $site_config['MySQL']['Username'];
$password = $site_config['MySQL']['Password'];

try {
	$conn = new PDO("mysql:host=$servername;dbname=zugent", $username, $password);
    // set the PDO error mode to exception
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    //echo "Connected successfully";
}
catch(PDOException $e) {
	echo "Connection failed: " . $e->getMessage();
}
?>
