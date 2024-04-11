<?php
/**
 * @name mob_get_propertie
 * @description Fetch a specific property by ID
 * @return JSON
 * @param <INT> <mls id>
 * @param <INT> <listing_number>
 */

require_once('connection.php');
require_once('mob_get_json.php');
$conn = $GLOBALS['conn'];
global $mls_data;

header("Content-Type: application/json");

$_REQUEST['mls_id'] = "3";
// $_REQUEST['listing_number'] = "1384455";

$sql = "select * from zugent.mls where mls_id=? limit 1";
$sth = $conn->prepare($sql);
if ($sth->execute(array($_REQUEST['mls_id'])) > 0) {
	$mls_data = $sth->fetch(PDO::FETCH_ASSOC);
	if ($mls_data['mls_id'] != $_REQUEST['mls_id']) {
		echo json_encode(array("data" => 0));
		exit;
	}
} else {
	echo json_encode(array("data" => 0));
	exit;
}

$sql = "
	select
		l.*
		,concat(a.first_name,' ', a.last_name) as listing_agent_name
		,o.office_name as office_name
		,lr.json_text
	from ".$mls_data['mls_database'].".listings as l
	left join ".$mls_data['mls_database'].".listings_raw as lr on l.listing_number=lr.listing_number
	left join ".$mls_data['mls_database'].".agents as a on a.agent_id=l.list_agent_id
	left join ".$mls_data['mls_database'].".offices as o on o.office_id=l.list_office_id
	where l.listing_number = ?
";


$sth = $conn->prepare($sql);
if ($sth->execute(array($_REQUEST['listing_number']))) {
	$prop_data = $sth->fetch(PDO::FETCH_ASSOC);
	$extended_data = json_decode($prop_data['json_text']);
	foreach($extended_data as $k => $v) {
		switch($k) {
			case "APS":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'APS', $v);
				break;
			case "STY":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'STY', $v);
				break;
			case "ARC":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'ARC', $v);
				break;
			case "MBD":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'MBD', $v);
				break;
			case "KES":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'KES', $v);
				break;
			case "KIT":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'KIT', $v);
				break;
			case "LRM":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'LRM', $v);
				break;
			case "BRM":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'BRM', $v);
				break;
			case "DRM":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'DRM', $v);
				break;
			case "EFR":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'EFR', $v);
				break;
			case "FAM":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'FAM', $v);
				break;
			case "RRM":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'RRM', $v);
				break;
			case "STL":
				$prop_data[$k] = fetch_amenity($prop_data['listing_type'], 'STL', $v);
				break;
			case "FEA":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'FEA', $v);
				break;
			case "FLS":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'FLS', $v);
				break;
			case "EQP":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'EQP', $v);
				break;
			case "HTC":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'HTC', $v);
				break;
			case "GR":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'GR', $v);
				break;
			case "NC":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'NC', $v);
				break;
			case "BDC":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'BDC', $v);
				break;
			case "CMFE":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'CMFE', $v);
				break;
			case "ENS":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'ENS', $v);
				break;
			case "WAS":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'WAS', $v);
				break;
			case "LDE":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'LDE', $v);
				break;
			case "LTV":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], 'LDE', $v);
				break;
			case "SWR":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], $k, $v);
				break;
			case "SIT":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], $k, $v);
				break;
			case "TRM":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], $k, $v);
				break;
			case "VEW":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], $k, $v);
				break;
			case "PARQ":
				$prop_data[$k] = fetch_amenities($prop_data['listing_type'], $k, $v);
				break;


			default:
				if (empty($v)) {
					$prop_data[$k] = "None";
				}
				else {
					$prop_data[$k] = $v;
				}
				break;
		}
	}
	$prop_data['json_text'] = '';
	$prop_data['images'] = [];
	if ($prop_data['LSF'] >= 10890) {
		$prop_data['LSF'] = round(($prop_data['LSF'] / 43560),2)." acre";
	} else {
		$prop_data['LSF'] = number_format($prop_data['LSF']);
	}
	$prop_data['lot_sqft'] = $prop_data['LSF'];
	$prop_data['ASF'] = number_format($prop_data['ASF']);
	$prop_data['finished_sqft'] = $prop_data['finished_sqft'];


	for ($x = 0; $x < $prop_data['photo_count']; $x++) {
		array_push($prop_data['images'], "https://zugidx.s3.amazonaws.com/650/{$mls_data['mls_name']}_".$prop_data['listing_number']."_{$x}.jpg");
	}
	echo json_encode(array("data" => $prop_data),JSON_PRETTY_PRINT);
} else {
	echo json_encode(array("data"=>0));
}

function fetch_amenities($ptyp, $code, $values) {
	global $mls_data;
	$conn = $GLOBALS['conn'];
	$ret_list = array();
	
	$split_values = explode("|", $values);
	$comma_separated = implode("','", $split_values);
	$comma_separated = "'".$comma_separated."'";
	$sql = "select * from ".$mls_data['mls_database'].".amenities where property_type=? and code=? and value_code in (".$comma_separated.")";
	$sth = $conn->prepare($sql);
	
	if ($sth->execute(array($ptyp, $code))) {
		while ($amenity_data = $sth->fetch(PDO::FETCH_ASSOC)) {
			if ($code == 'STY') $amenity_data['value_desc'] = array_pop(explode(" - ", $amenity_data['value_desc']));
			$ret_list[] = $amenity_data['value_desc'];
		}
	}

	if (count($ret_list) == 0) $ret_list[] = "None";
	
	return $ret_list;
}


function fetch_amenity($ptyp, $code, $value) {
	global $mls_data;
	$conn = $GLOBALS['conn'];
	$fetch_data = "";

	$sql = "select * from ".$mls_data['mls_database'].".amenities where property_type=? and code=? and value_code = ?";
	$sth = $conn->prepare($sql);

	if ($sth->execute(array($ptyp, $code, $value))) {
		while ($amenity_data = $sth->fetch(PDO::FETCH_ASSOC)) {
			$fetch_data = $amenity_data['value_desc'];
		}
	}

	return $fetch_data;
}



?>
