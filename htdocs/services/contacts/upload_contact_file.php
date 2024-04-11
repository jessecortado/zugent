<?php

// require_once($_SERVER['SITE_DIR']."bin/rets/idx_listings.php");

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x0c7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'contacts',
	"main_table_field" => 'contact_id',
	"main_field_value" => $_POST['contact_id'],
	"table_join_name" => 'contacts_rel_users',
	"table_join_field" => 'contact_id',
	"additional_where" => array(
		"t1.contact_id" => $_POST["contact_id"],
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.user_id" => $_SESSION['user']['user_id'],
		"t2.contact_id" => $_POST["contact_id"],
		"t2.is_deleted!" => '1'
		)
);

auth_process($data, $is_ajax);

 	
if(isset($_POST['contact_id'])){

	$s3Client = S3Client::factory(array(
	    'key'    => 'AKIAJ7MLE7RT54HBO6XQ',
	    'secret' => '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'
	));

 	$user_id = $_SESSION['user_id'];

 	// move to directory working
	// $targetDir = "/Applications/xampp/xamppfiles/htdocs/jason_granum/repo1/htdocs/assets/img/login-bg/";
	// $fileName = $_FILES["file"]["name"];
	// $targetFile = $targetDir.$fileName;

	// move_uploaded_file($_FILES['file']['tmp_name'],$targetFile);
	
	if(isset($_FILES['file']['tmp_name'])){

	    $tempfile = $_FILES['file']['tmp_name'];
	 	$filename = preg_replace("/[^A-Za-z0-9.]/", '',$_FILES['file']['name']);
	 	$object_url;
	 	$date = gmdate("Y-m-d H:i:s");
	 	$key = '/contact_files/'.SQL_CLEAN($_POST['contact_id']).'/'.$filename;
 		if (file_exists($tempfile)) {
 			try {
	            $result = $s3Client->putObject(array(
					'Bucket'     => 'zugent',
					'Key'        => $key,
					'SourceFile' => $tempfile
	            ));  
	            $object_url = $result['ObjectURL'];
			} catch (S3Exception $e) {
			    echo $e->getMessage() . "\n";
			}
        }

        SQL_QUERY("insert into contact_files set 
        	file_key='".$key.
        	"', file_name='".SQL_CLEAN($filename).
        	"', is_deleted=0".
        	", user_id=".SQL_CLEAN($_SESSION['user_id']).
        	", file_type_id=".SQL_CLEAN($_POST['file_type_id']).
        	", date_uploaded='".SQL_CLEAN($date).
        	"', contact_id=".SQL_CLEAN($_POST['contact_id']).
        	""
        	);

		$contact_file_id = SQL_INSERT_ID();
	
		// Add contact log (Add)
		add_user_log("Added a contact file (".$_POST['contact_file_id'].") to contact (".$_POST['contact_id'].")", "contacts", array("importance" => "Info", "action" => "Add") );

		$sth = SQL_QUERY("select * from users where user_id=".$_SESSION['user_id']);
		$user_data = SQL_ASSOC_ARRAY($sth);
		$_SESSION['user'] = $user_data;

		$sth3 = SQL_QUERY("select cf.*, cft.name as file_type_name from contact_files as cf 
			left join file_types as cft on cft.file_type_id = cf.file_type_id 
			where cf.contact_id=".SQL_CLEAN($_POST['contact_id'])." and cf.contact_file_id=".SQL_CLEAN($contact_file_id)." and cf.is_deleted=0 limit 1");

		$recently_uploaded_data = array();

		while($data = SQL_ASSOC_ARRAY($sth3)) {
		 	$recently_uploaded_data[] = $data;
		}

		echo json_encode(array('msg'=>true, 'data'=>$recently_uploaded_data));

        @unlink($filename);
     
	}
	else {
		// echo json_encode("no file sent \n");
		// print_r($_FILES);
		header("location: /dashboard.php?code=1x0c7");
	}
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0c7");
	}
}

?>
