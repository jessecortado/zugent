<?php
include_once('connection.php');
require_once('mob_get_json.php');

/**
 * @param  [type]
 * @param  [type]
 * @param  [type]
 * @return [type]
 */
function search_properties($latitude, $longitude){
	$conn = $GLOBALS['conn'];
	$getCompId = array(); //store database name
	$error = array();
	$listings = array();
	$listingsFilter = array();

	/**
	 * [$i description]
	 * Fetch all company IDS. For now, loop up to 5 since there is no difinite value of company IDs yet.  
	 */
	for($i=1;$i<=5;$i++) {
		$company_id = $i;
		$sql = "SELECT * FROM zugent.mls as t1 INNER JOIN zugent.company_rel_mls as t2 ON t1.mls_id = t2.mls_id and t2.company_id = {$company_id}";
		$stmt = $conn->query($sql);
		$row = $stmt->fetchAll(PDO::FETCH_OBJ);	
		foreach($row as $db){
			$getCompId[$db->mls_id] = $db;
		}
	}

	/**
	 * Use each company ID to fetch all listings
	 * NEED TO CHANGE RANGE FOR LAT AND LONG!
	 */
	foreach ($getCompId as $value) {
		$dbase = $value->mls_database;
		$urlImg = "https://zugidx.s3.amazonaws.com/650/{$dbase}_";
		$dbase_listings = $dbase.'.listings';
		$sql2 = "SELECT * FROM {$dbase_listings} WHERE latitude=:latitude AND longitude=:longitude ORDER BY listing_number DESC";
		$stmt2 = $conn->prepare($sql2);
		$stmt2->bindParam(':latitude', $latitude);
		$stmt2->bindParam(':longitude', $longitude);
		$stmt2->execute();
		$result = $stmt2->fetchAll(PDO::FETCH_OBJ);
		$listings[] = array($result, $urlImg);
		$error[] = $conn->errorInfo();
	}

	$listingsCount = count($listings);

	/**
	 * check if $listings array contains values. 
	 */
	
	foreach ($listings as $key => $value) {
		if (empty($listings[$key][0]) === false) {
			$listingsFilter[] = $value;
		}
	}
	return json_encode($getCompId);
}

echo search_properties('43.74657305081979','-73.2103053330505');
?>