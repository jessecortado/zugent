<?php
/**
 * [$site_config description]
 * @var [type]
 * @description 
 */

require_once('connection.php');
require_once('mob_get_json.php');

header('Access-Control-Allow-Origin: *');

$conn = $GLOBALS['conn'];
$page = 1; //Default
$mls_id = 3; //default value


if(isset($_POST['mls_number'])) {
	$mls_number = $_POST['mls_number'];

	$sql = "SELECT mls_database FROM zugent.mls WHERE mls_id in ({$mls_id})";
	$stmt = $conn->query($sql);
	$row = $stmt->fetchAll(PDO::FETCH_OBJ);

	foreach($row as $db) {
		$dbase = $db->mls_database;

		$sql = "SELECT ";
		$sql .= " l.listing_number";
		$sql .= " FROM {$dbase}.listings as l WHERE";
		$sql .= " l.STATUS IN ('A','P','PI','PS','PF','PB')";
		$sql .= " AND l.listing_number = {$mls_number}";
		$sql .= " LIMIT {$page}";

		$stmt = $conn->query($sql);

		if($stmt->rowCount() > 0){
			echo json_encode(array("error" => false, "exists" => true));
		}
		else {
			echo json_encode(array("error" => false, "exists" => false));
		}
	}

	exit;

}
else {
	echo json_encode(array("error" => true));
	exit;
}
?>
