<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

$sth = SQL_QUERY("select pi.* from pool_imports as pi  
	left join pools as p on pi.pool_id=p.pool_id 
	left join users as u on p.user_id=u.user_id 
	where pi.pool_import_id=".SQL_CLEAN($_GET['id'])." 
	and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id']));

if (SQL_NUM_ROWS($sth) != 1) {
	print "<h1>Maintenance</h1>";
	exit;
}

$s3Client = S3Client::factory(array(
	    'key'    => 'AKIAJ7MLE7RT54HBO6XQ',
	    'secret' => '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'
	));

$sth = SQL_QUERY("select * from pool_imports where pool_import_id='".SQL_CLEAN($_GET['id'])."' limit 1");
if (SQL_NUM_ROWS($sth) != 1) {
	print "<h1>Error 404: File not found</h1>";
	exit;
}

if (SQL_NUM_ROWS($sth) == 1) {
	$data = SQL_ASSOC_ARRAY($sth);
	
	try {
	    // Get the object
	    $result = $s3Client->getObject(array(
	        'Bucket' => 'zugent',
	        'Key'    => $data['file_key']
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