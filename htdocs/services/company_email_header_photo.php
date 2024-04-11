<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

 	use Aws\S3\S3Client;
	use Aws\S3\Exception\S3Exception;

	$s3Client = S3Client::factory(array(
	    'key'    => 'AKIAJ7MLE7RT54HBO6XQ',
	    'secret' => '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'
	));


	if (!isset($_POST['company_id']))
		$company_id = $_SESSION['user']['company_id'];
	else
		$company_id = $_POST['company_id'];

	
	if (isset($_FILES['file'])) {

	    $tempfile = $_FILES['file']['tmp_name'];
	 	$filename = $_FILES['file']['name'];

 		if (file_exists($tempfile)) {
 			try {

	            $result = $s3Client->putObject(array(
					'Bucket'     => 'zugent',
					'Key'        => 'companyemailphotos/'.$company_id.'/'.'original.jpg',
					'SourceFile' => $tempfile
	            ));  
	            $object_url = $result['ObjectURL'];

			} catch (S3Exception $e) {
			    echo $e->getMessage() . "\n";
			}
        }

		SQL_QUERY("update companies set url_email_logo='".str_replace('/', '\\/',$object_url)."' where company_id='".SQL_CLEAN($company_id)."'");

		//Refresh Company Session
		$sth = SQL_QUERY("select * from companies where company_id=".SQL_CLEAN($company_id));
		$company_data = SQL_ASSOC_ARRAY($sth);
		$_SESSION['company'] = $company_data;

        echo json_encode($object_url);

        @unlink($filename);
     
	}

?>