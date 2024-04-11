<?php

// require_once($_SERVER['SITE_DIR']."bin/rets/idx_listings.php");

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

error_reporting(E_ERROR | E_WARNING | E_PARSE);

// ini_set('auto_detect_line_endings',TRUE);

$s3Client = S3Client::factory(array(
	    'key'    => 'AKIAJ7MLE7RT54HBO6XQ',
	    'secret' => '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'
	));

$fields = array();
$leads = array();

// Number of rows to show for the confirmation of import
$rows_to_show = 10;
// Existing columns in the pool leads table
$existing_columns = array('full_name', 'first_name', 'last_name', 'phone_0', 'phone_1', 'phone_2', 'phone_3', 'phone_4', 'phone_5', 'phone_6', 'phone_7', 'phone_8', 'phone_9', 'address_line_1', 'address_Line_2', 'city', 'state', 'zip', 'county', 'email', 'lead_note', 'upload_note', );
// Which columns to show for the confirmation of import
$fields_to_show = array('Name', 'Phone', 'Phone_0', 'Email');

function csvToJson($csv) {
	$rows = explode("\n", trim($csv));
	$csvarr = array_map(function ($row) {
		$keys = array('Name', 'First_Name', 'Last_Name', 'Phone_0', 'Phone_1', 'Phone_2', 'Phone_3', 'Phone_4', 'Phone_5', 'Phone_6', 'Phone_7', 'Phone_8', 'Phone_9', 'Phone_10', 'Address', 'Address_2', 'City', 'State', 'Zip', 'County', 'Email', 'Notes');
		return array_combine($keys, str_getcsv($row));
	}, $rows);

    // $json = json_encode($csvarr);

	return $csvarr;
}

if(isset($_POST['action'])) {
	if($_POST['action'] == "upload_file") {
		if(isset($_POST['pool_id'])) {

			$user_id = $_SESSION['user_id'];
			
			if(isset($_FILES['file']['tmp_name'])) 
			{

		 		// Start Validation
				$csv_mimetypes = array(
					'text/csv',
					'text/plain',
					'application/csv',
					'text/comma-separated-values',
					'application/excel',
					'application/vnd.ms-excel',
					'application/vnd.msexcel',
					'text/anytext',
					'application/octet-stream',
					'application/txt',
					'text/plain'
					);

				if (!in_array($_FILES['file']['type'], $csv_mimetypes)) {
					exit;
				}

				// $info = pathinfo($_FILES['file']['tmp_name']);

				// if($info['extension'] !== 'csv'){
				// 	exit;
				// }
				// End Validation

				$tempfile = $_FILES['file']['tmp_name'];
				$filename = basename(preg_replace("/[^A-Za-z0-9.]/", '',$_FILES['file']['name']));
				$dir = $_SERVER['SITE_DIR'].'uploads/temp/';
				$key = '/pool_imports/'.$_POST['pool_id'].'/'.$filename;

				$row = 0;
				$array;

				$sth = SQL_QUERY("insert into pool_imports set 
					file_key='".$key.
					"', original_filename='".SQL_CLEAN($filename).
					"', pool_id=".SQL_CLEAN($_POST['pool_id']).
					", user_id=".SQL_CLEAN($_SESSION['user_id']).
					", date_uploaded=NOW()"
					);

				$import_id = SQL_INSERT_ID();
				$file_url = "";

				$date = gmdate("Y-m-d H:i:s");
				if (file_exists($tempfile)) {
					try {
						$result = $s3Client->putObject(array(
							'Bucket'     => 'zugent',
							'Key'        => $key,
							'SourceFile' => $tempfile
							));  
						$file_url = $result['ObjectURL'];
					} catch (S3Exception $e) {
						echo $e->getMessage() . "\n";
					}
				}

				// Change to read object placed in s3 from fopen($tempfile, "r"))
				// store column numbers of fields found in a separate array

				$fields_found = array();
				if (($handle = fopen($file_url, "r")) !== FALSE) {
					while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) { 

						// echo json_encode($data);
						// $array = array_map("str_getcsv", explode("\n", $data));

						if($row > $rows_to_show) {
							break;
						}

						$num = count($data);
			 				// echo "<p> $num fields in line $row: <br /></p>\n";
						for ($c=0; $c < $num; $c++) {
							if($row == 0) {
								$name = str_replace(' ', '_', $data[$c]);

								if (in_array($name, $fields_to_show)) {

									$fields[] = $data[$c];
									// Start storing column numbers of fields to show
									$fields_found[] = $c;
								}
							}
							else {
								// die(count($fields_found));
								// $item = $data[$c];
								// if(!mb_detect_encoding($item, 'utf-8', true)){
								// 	$item = utf8_encode($item);
								// }
								// $name = str_replace(' ', '_', strtolower($fields[$c]));
								// $leads[$row-1][$name] = $item;

								for ($c2=0; $c2 < count($fields_found); $c2++) {
									$leads[$row-1][$c2] = $data[$fields_found[$c2]];
								}

								
								break;

							}
						}

						$row++;
					}

					echo json_encode(array("fields" => $fields, "leads" => $leads, "id" => $import_id, "url" => $file_url, "fields_found" => $fields_found));

						$_SESSION['uploaded_file'] = $dir.$filename;
						$_SESSION['pool_id'] = $_POST['pool_id'];
					

					fclose($handle);
				}

				@unlink($tempfile);

			}
			else {
				echo json_encode("no file sent \n");
			}
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] = "confirm_upload") {
		if(isset($_POST['pool_id'])) {
			if($_POST['pool_id'] == $_SESSION['pool_id']) {

				// $file = $_SESSION['uploaded_file'];
				// Test from url
				$file = $_POST['file_url'];
				$fields_str = "";
				$created_count = 0;
				$error_count = 0;
				$duplicate_count = 0;
				$row = 0;


				if (($handle = fopen($file, "r")) !== FALSE) {

					$json_keys = array();
					$columns_not_found = array();

					while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) { 

						$json_data = array();
						$values_str = "";
						$continue = true;

						$num = count($data);

						for ($c=0; $c < $num; $c++) {
							if($row == 0) {
								$name = str_replace(' ', '_', strtolower($data[$c]));

								// convert to utf-8
								$item = $name;
								if(!mb_detect_encoding($item, 'utf-8', true)) {
									$item = utf8_encode($item);
								}

						        // name to full_name, address to address_line_1, address 2 to address_line_2
								if($item === "name") {
									$item = "full_name";
								}
								else if($item == "address") {
									$item = "address_line_1";
								}
								else if($item == "address_2") {
									$item = "address_line_2";
								}
								else if($item == "notes") {
									$item = "upload_note";
								}
								else if($item == "phone") {
									$item = "phone_0";
								}
								
								if (!in_array($item, $existing_columns)) {
									$json_keys["$c"] = $item;
									$columns_not_found[] = "$c";
									continue;
								}

								$fields[] = $item;

								$fields_str .= $item;

								$fields_str .= ",";
								
							}
							else { 

								$item = $data[$c];
								if(!mb_detect_encoding($item, 'utf-8', true)){
									$item = utf8_encode($item);
								}

						        // name to full_name, address to address_line_1, address 2 to address_line_2
								if($item === "name") {
									$item = "full_name";
								}
								else if($item == "address") {
									$item = "address_line_1";
								}
								else if($item == "address_2") {
									$item = "address_line_2";
								}
								else if($item == "notes") {
									$item = "upload_note";
								}  

								if (in_array($c, $columns_not_found)) {
									$json_data[] = array( $json_keys["$c"] => $item); 
									continue;
								}

								$name = str_replace(' ', '_', strtolower($fields[$c]));
								$leads[$row-1][$name] = $item;

								$values_str .= "'".$item."'";

								$values_str .= ",";


							}
						}


						if($continue && $row > 0) {
							$check_for_dupes = SQL_QUERY("select * from pool_leads where pool_id=".SQL_CLEAN($_POST['pool_id'])." and 
								(city='".$leads[$row-1]['city']."' and
									address_line_1='".$leads[$row-1]['address_line_1']."' and
									state='".$leads[$row-1]['state']."' and
									zip='".$leads[$row-1]['zip']."')");

							if(SQL_NUM_ROWS($check_for_dupes) > 0) {
								$duplicate_count++;
								continue;
							} 
							else {
								try {
									SQL_QUERY("insert into pool_leads (pool_id,user_id,date_added,".$fields_str."raw_data) values (".SQL_CLEAN($_POST['pool_id']).",".$_SESSION['user']['user_id'].",NOW(),".$values_str."'".SQL_CLEAN(json_encode($json_data))."')");
									$created_count++;
								} catch(EXCEPTION $e) {
									$error_count++;
									echo json_encode($e);
								}
							}
						}

						$row++;

					}


				// Update pool_import to be imported=1
				$sth = SQL_QUERY("update pool_imports set 
					imported=1 
					, leads_created=".SQL_CLEAN($created_count)."
					, leads_dupe=".SQL_CLEAN($duplicate_count)."
					, leads_error=".SQL_CLEAN($error_count)." 
					where pool_import_id=".SQL_CLEAN($_POST['import_id']));

					echo json_encode(array("created_count" => $created_count, "duplicate_count" => $duplicate_count, "error_count" => $error_count));

					fclose($handle);
				}

			}
		}
	}
	else {
		echo json_encode("Something is wrong");
	}
}

else {
	echo json_encode("Maintenance");
}

ini_set('auto_detect_line_endings',FALSE);
?>