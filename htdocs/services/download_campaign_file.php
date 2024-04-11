<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

$s3Client = S3Client::factory(array(
    'key'    => 'AKIAJ7MLE7RT54HBO6XQ',
    'secret' => '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'
));

$sth = SQL_QUERY("select * from campaign_event_rel_contacts where contact_id='".SQL_CLEAN($_REQUEST['uid'])."' and campaign_event_contact_id='".SQL_CLEAN($_REQUEST['cid'])."' and campaign_id='".SQL_CLEAN($_REQUEST['caid'])."' limit 1");
if (SQL_NUM_ROWS($sth) != 1) {
	print "<h1>Error 404: File not found</h1>";
	exit;
}
$cdata = SQL_ASSOC_ARRAY($sth);

if ($cdata['date_file_opened'] == '0000-00-00 00:00:00') SQL_QUERY("update campaign_event_contact_id set date_file_opened=NOW() where campaign_event_contact_id='".SQL_CLEAN($_REQUEST['cid'])."' limit 1");
$sth = SQL_QUERY("select * from campaign_downloads where campaign_download_id='".SQL_CLEAN($_REQUEST['id'])."' limit 1");
if (SQL_NUM_ROWS($sth) == 1) {
	$data = SQL_ASSOC_ARRAY($sth);
	
	// Add campaign log
	add_user_log("Downloaded a campaign file (".$_REQUEST['id'].")", "campaigns", array("importance" => "Info", "action" => "Download") );

	try {
	    // Get the object
	    $result = $s3Client->getObject(array(
	        'Bucket' => 'zugent',
	        'Key'    => $data['s3_key']
	    ));
		header("Content-Type: application/octet-stream");
		header("Content-Disposition: attachment; filename=\"".$data['original_filename']."\"");
	    echo $result['Body'];
		exit;
	} catch (S3Exception $e) {
		print "<h1>500 Error</h1>";
		print "<p>An error has occurred.</p>";
		print "<p>".$e->getMessage()."</p>";
	}
}
exit;
?>