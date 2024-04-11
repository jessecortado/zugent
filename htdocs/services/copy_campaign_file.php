<?php
// require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

function copy_file($copy_id, $new_id, $data=null) {

	$s3Client = S3Client::factory(array(
		'key'    => 'AKIAJ7MLE7RT54HBO6XQ',
		'secret' => '8vXm0TuKT6C2getoTJ/dE6KP2Ag3yIZ+PaVtLVQA'
	));

	$s3_key = 'campaign_files/'.$new_id.'/'.preg_replace("/[^A-Za-z0-9.]/", '',$data['file_label']);

	$sth = SQL_QUERY("
		insert into campaign_downloads set 
		campaign_id='".SQL_CLEAN($new_id).
		"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
		"', original_filename='".SQL_CLEAN($data['original_filename']).
		"', file_label='".SQL_CLEAN($data['file_label']).
		"', s3_key='".SQL_CLEAN($s3_key).
		"'");

	$cd_id = SQL_INSERT_ID();
	
	// Add campaign log
	add_user_log("Add a campaign file (".$cd_id.")", "campaigns", array("importance" => "Info", "action" => "Download") );

	// try {
		// Get the object
		$result = $s3Client->getObject(array(
			'Bucket' => 'zugent',
			'Key'    => $data['s3_key']
			));

		// header("Content-Type: application/octet-stream");
		// header("Content-Disposition: attachment; filename=\"".$data['original_filename']."\"");
		// echo $result['Body'];

		$result = $s3Client->putObject(array(
			'Bucket'     => 'zugent',
			'Key'        => $s3_key,
			'Body' => $result['Body']
			));

		        // die($result['ObjectURL']);

	// } catch (S3Exception $e) {
	// 	print "<h1>500 Error</h1>";
	// 	print "<p>An error has occurred.</p>";
	// 	die("<p>".$e->getMessage()."</p>");
	// }
	
}

?>