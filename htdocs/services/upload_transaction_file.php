<?php

// require_once($_SERVER['SITE_DIR']."bin/rets/idx_listings.php");

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

// $sth = SQL_QUERY("select t.* 
// 					from transactions as t 
// 					left join users as u on u.user_id=t.user_id 
// 					where t.transaction_id=".SQL_CLEAN($_POST['transaction_id'])." and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])
// 				);

// if (SQL_NUM_ROWS($sth) == 0) {
// 	print "0";
// 	exit;
// }

	use Aws\S3\S3Client;
	use Aws\S3\Exception\S3Exception;

	// if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') 
 //    {
 //        echo "RECEIVED ON SERVER: \n";
 //        echo "FILES: \n";
 //        print_r($_FILES);
 //        echo "\$_POST: \n";
 //        print_r($_POST);
 //    }

	// exit;
 	
	if($_POST['action'] == "upload_file"){
		if(isset($_POST['transaction_id'])){

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
			
			if(isset($_FILES['file']['tmp_name']))  
    		{
    			// die('here');
			    $tempfile = $_FILES['file']['tmp_name'];
			 	$filename = preg_replace("/[^A-Za-z0-9.]/", '',$_FILES['file']['name']);
			 	$object_url;
			 	$date = date("Y-m-d H:i:s");
			 	$key = '/transaction_files/'.SQL_CLEAN($_POST['transaction_id']).'/'.$filename;

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

		        $date = date("Y-m-d H:i:s");

		        $result = SQL_QUERY("insert into transaction_files set 
		        	file_key='".$key.
		        	"', file_name='".SQL_CLEAN($filename).
		        	"', is_deleted=0".
		        	", user_id=".SQL_CLEAN($_SESSION['user_id']).
		        	", file_type_id=".SQL_CLEAN($_POST['file_type_id']).
		        	", date_uploaded=NOW()".
		        	", transaction_id=".SQL_CLEAN($_POST['transaction_id']).
		        	""
					);

				$transaction_file_id = SQL_INSERT_ID();
					
				// Add transaction log
				add_user_log("Uploaded a transaction file (".$transaction_file_id.") to transaction_id=".$_POST['transaction_id'], "transaction", array("importance" => "Info", "action" => "Upload") );

		        echo json_encode(array("url"=>$object_url, "result"=>$result));

		        @unlink($filename);
		     
			}
			else {
				echo json_encode("no file sent \n");
				// print_r($_FILES);
			}
		}
		else {
			echo json_encode("No id sent");
		}
	}
	else {
		echo json_encode("Something is wrong");
	}
?>
