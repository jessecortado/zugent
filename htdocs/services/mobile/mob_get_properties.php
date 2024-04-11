<?php
/**
 * @name mob_get_properties
 * @description Fetch all properties within 100 miles radius.
 * @return JSON
 * @param <FLOAT> <latitude>
 * @param <FLOAT> <longitude>
 * @param <INT> <row>
 * @date June 2018
 * @author [Joy Victoria] [<jvictoria@zugent.com>]
 */

require_once('connection.php');
require_once('mob_get_json.php');
$conn = $GLOBALS['conn'];
$page = 100; //Default
$distance = 100; //original value: 500
$mls_id = 3; //default value
$properties = array();
// $geojson = array(
//    'type'      => 'FeatureCollection',
//    'features'  => array()
// );

// Filters
$min_price = 0;
$max_price = 0;
$min_sqft = 0;
$max_sqft = 0;
$min_lotsize = 0;
$max_lotsize = 0;
$min_yearbuilt = 0;
$max_yearbuilt = 0;
$beds = "";
$baths = "";
$types = "";

if (isset($_REQUEST)) {
	$lat1 = $_REQUEST['lat1'];
	$lon1 = $_REQUEST['lon1'];
	$lat2 = $_REQUEST['lat2'];
	$lon2 = $_REQUEST['lon2'];
	if(isset($_REQUEST['row'])){
		$page = $_REQUEST['row'];
	} else {
		$page = 100;
	}

	if($lat1 > $lat2){
		$lat1 = $_REQUEST['lat2'];
		$lat2 = $_REQUEST['lat1'];
	}

	if($lon1 > $lon2){
		$lon1 = $_REQUEST['lon2'];
		$lon2 = $_REQUEST['lon1'];
	}

	$lat_c = $lat1 + (($lat2-$lat1)/2);
	$lon_c = $lon1 + (($lon2-$lon1)/2);

	// FILTERS
	if (isset($_REQUEST['min_price'])) {
		$min_price = (int)$_REQUEST['min_price'];
	}

	if (isset($_REQUEST['max_price'])) {
		$max_price = (int)$_REQUEST['max_price'];
	}

	if (isset($_REQUEST['min_sqft'])) {
		$min_sqft = (int)$_REQUEST['min_sqft'];
	}

	if (isset($_REQUEST['max_sqft'])) {
		$max_sqft = (int)$_REQUEST['max_sqft'];
	}
	
	if (isset($_REQUEST['min_lotsize'])) {
		$min_lotsize = (int)$_REQUEST['min_lotsize'];
	}

	if (isset($_REQUEST['max_lotsize'])) {
		$max_lotsize = (int)$_REQUEST['max_lotsize'];
	}
	
	if (isset($_REQUEST['min_yearbuilt'])) {
		$min_yearbuilt = (int)$_REQUEST['min_yearbuilt'];
	}

	if (isset($_REQUEST['max_yearbuilt'])) {
		$max_yearbuilt = (int)$_REQUEST['max_yearbuilt'];
	}

	if (isset($_REQUEST['beds'])) {
		$beds = $_REQUEST['beds'];
	}

	if (isset($_REQUEST['baths'])) {
		$baths = $_REQUEST['baths'];
	}

	if (isset($_REQUEST['property_types']) && !empty($_REQUEST['property_types'])) {
		$types = join("','", $_REQUEST['property_types']);
	}

	/**
	 * [$sql fetch properties listed within coordinates with a distance of {$distance}]
	 * @var string
	 * @author [Carena] <[<email address>]>
	 */
	$sql = "SELECT mls_database FROM zugent.mls WHERE mls_id in ({$mls_id})";
	$stmt = $conn->query($sql);
	$row = $stmt->fetchAll(PDO::FETCH_OBJ);
	foreach($row as $db){
		$dbase = $db->mls_database;
		$sql = "SELECT ";
		$sql .= " l.listing_number, l.address, l.county, l.city, l.state, l.zip, l.photo_count, l.status, l.listing_type";
		$sql .= " , l.price, l.beds_total, l.baths_total, l.year_built, l.finished_sqft, l.lot_sqft, l.latitude, l.longitude";
		$sql .= " , l.date_photo_retrieved";


		// $sql .= " , (abs({$lat_c} - l.latitude) + abs({$lon_c} - l.longitude)) as dist";
		// $sql .= ", ROUND(6378.137 * 2 * ASIN(SQRT(POW(SIN(({$lat}*PI()/180-latitude * PI()/180)/2),2) + COS({$lat} * PI() / 180)*COS(latitude * PI() / 180) * POW(SIN(({$lng} * PI() / 180.0 - longitude * PI() / 180)/2),2))) * 10000) / 10000  as dis ";
		// $sql .= " FROM {$dbase}.listings HAVING dis <= {$distance} ORDER BY dis LIMIT {$page}";
		// $sql .= " FROM {$dbase}.listings WHERE latitude between {$lat1} AND {$lat2} AND longitude between {$lon1} AND {$lon2} LIMIT 100";

		$sql .= " , ( 3959 * acos ( cos ( radians({$lat_c}) ) * cos( radians( l.latitude ) ) * ";
		$sql .= "   cos( radians( l.longitude ) - radians({$lon_c}) ) + sin ( radians({$lat_c}) ) * ";
		$sql .= "   sin( radians( l.latitude ) ) ) ) AS dist ";


		$sql .= " FROM {$dbase}.listings as l WHERE ";
		$sql .= " l.STATUS IN ('A','P','PI','PS','PF','PB') ";
		$sql .= " AND l.latitude between {$lat1} AND {$lat2} ";
		$sql .= " AND l.longitude between {$lon1} AND {$lon2} ";


		// FILTER PROPERTIES
		// Filter by Price
		if ($min_price != 0  && $max_price != 0) {
			$sql .= " AND l.price BETWEEN {$min_price} AND {$max_price} ";
		}
		else {
			if ($min_price != 0) {
				$sql .= " AND l.price >= {$min_price} ";
			}
			else if ($max_price != 0) {
				$sql .= " AND l.price <= {$max_price} ";
			}
		}

		// Filter by Square Foot
		if ($min_sqft != 0  && $max_sqft != 0) {
			$sql .= " AND l.finished_sqft BETWEEN {$min_sqft} AND {$max_sqft} ";
		}
		else {
			if ($min_sqft != 0) {
				$sql .= " AND l.finished_sqft >= {$min_sqft} ";
			}
			else if ($max_sqft != 0) {
				$sql .= " AND l.finished_sqft <= {$max_sqft} ";
			}
		}

		// Filter by Lot Size
		if ($min_lotsize != 0  && $max_lotsize != 0) {
			$sql .= " AND l.lot_sqft BETWEEN {$min_lotsize} AND {$max_lotsize} ";
		}
		else {
			if ($min_lotsize != 0) {
				$sql .= " AND l.lot_sqft >= {$min_lotsize} ";
			}
			else if ($max_lotsize != 0) {
				$sql .= " AND l.lot_sqft <= {$max_lotsize} ";
			}
		}

		// Filter by Year Built
		if ($min_yearbuilt != 0  && $max_yearbuilt != 0) {
			$sql .= " AND l.year_built BETWEEN {$min_yearbuilt} AND {$max_yearbuilt} ";
		}
		else {
			if ($min_yearbuilt != 0) {
				$sql .= " AND l.year_built >= {$min_yearbuilt} ";
			}
			else if ($max_yearbuilt != 0) {
				$sql .= " AND l.year_built <= {$max_yearbuilt} ";
			}
		}

		// Filter by Beds
		if ($beds != "") {
			$sql .= " AND l.beds_total >= {$beds} ";
		}

		// Filter by Baths
		if ($baths != "") {
			$sql .= " AND l.baths_total >= {$baths} ";
		}

		// FIlter by Property Types
		if ($types != "") {
			$sql .= " AND l.listing_type IN ('".$types."') ";
		}

		// Check for 
		$sql .= " AND (l.date_photo_retrieved != '0000-00-00 00:00:00' AND l.date_photo_retrieved IS NOT NULL) ";

		$sql .= " ORDER BY dist";
		$sql .= " LIMIT {$page}";
		$stmt = $conn->query($sql);
		if($stmt->rowCount() > 0){
			while ($property = $stmt->fetch(PDO::FETCH_ASSOC)) {
				$property['images'] = [];
				for ($x = 0; $x < $property['photo_count']; $x++) {
					$photo_name_db = str_replace("idx_","",$dbase);
					// $property['img_'.$x] = "https://zugidx.s3.amazonaws.com/650/{$photo_name_db}_".$property['listing_number']."_{$x}.jpg";
					array_push($property['images'], "https://zugidx.s3.amazonaws.com/650/{$photo_name_db}_".$property['listing_number']."_{$x}.jpg");
				}
				$properties[] = $property;
			}

			// while ($property = $stmt->fetch(PDO::FETCH_ASSOC)) {
			// 	$property['images'] = [];

			// 	for ($x = 0; $x < $property['photo_count']; $x++) {
			// 		$photo_name_db = str_replace("idx_","",$dbase);
			// 		// $property['img_'.$x] = "https://zugidx.s3.amazonaws.com/650/{$photo_name_db}_".$property['listing_number']."_{$x}.jpg";
			// 		array_push($property['images'], "https://zugidx.s3.amazonaws.com/650/{$photo_name_db}_".$property['listing_number']."_{$x}.jpg");
			// 	}

			//     $feature = array(
			//         'type' => 'Feature', 
			//         'geometry' => array(
			//             'type' => 'Point',
			//             'coordinates' => array(floatval($property['longitude']), floatval($property['latitude']))
			//         ),
			//         'properties' => $property
			//     );

			//     # Add feature arrays to feature collection array
			//     array_push($geojson['features'], $feature);

			// 	$properties[] = $geojson;
			// 	$properties[] = $property;
			// }
		}
	}
	if(empty($properties)) {
		echo json_encode(array("data"=> array()));
	} else {

		// $filename = "mob_properties.geojson";

		// $fhandle = fopen($filename,"w+");
		// fwrite($fhandle, json_encode($geojson));
		// fclose($fhandle);

		// header('Content-type: application/json');
		// echo json_encode($properties, JSON_NUMERIC_CHECK);

		echo json_encode(array("data" => $properties, "types" => $types, "post_types" => $_REQUEST['property_types']));
	}
} else {
	echo json_encode(array("data"=>0));
}
?>
