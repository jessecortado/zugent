<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

$s3Client = S3Client::factory(array(
    'key'    => 'AKIAJ7MLE7RT54HBO6XQ',
    'secret' => '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'
));

if (isset($_POST['campaign_id'])) {

    $tempfile = $_FILES['file']['tmp_name'];
 	$filename = $_FILES['file']['name'];

 	$filename = preg_replace("/[^A-Za-z0-9.]/", '', $filename);

	if (file_exists($tempfile)) {
		try {
	        $result = $s3Client->putObject(array(
				'Bucket'     => 'zugent',
				'Key'        => 'campaign_files/'.$_REQUEST['campaign_id'].'/'.$filename,
				'SourceFile' => $tempfile
	        ));
	        $object_url = $result['ObjectURL'];
		} catch (S3Exception $e) {
		    echo $e->getMessage() . "\n";
		}

		$sth = SQL_QUERY("
			insert into campaign_downloads (
				user_id
				, campaign_id
				, original_filename
				, s3_key
				, file_label
			) values (
				'".SQL_CLEAN($_SESSION['user_id'])."'
				,'".SQL_CLEAN($_REQUEST['campaign_id'])."'
				,'".SQL_CLEAN($_FILES['file']['name'])."'
				,'".SQL_CLEAN('campaign_files/'.$_REQUEST['campaign_id'].'/'.$filename)."'
				,'".SQL_CLEAN($_REQUEST['campaign_file_label'])."'
			)
		");

	    echo json_encode(array("url" => $object_url, "result" => $sth));

	    exit;
	}
}
echo 0;
?>