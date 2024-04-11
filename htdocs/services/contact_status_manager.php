<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

if(isset($_POST['action'])){

	if($_POST['action'] == "add_bucket"){
		if(isset($_POST['bucket_name'])){
			$sth = SQL_QUERY("
					insert into 
						contact_buckets set  
						is_dashboard=0, 
						bucket_name='".SQL_CLEAN($_POST['bucket_name'])."', company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
				");

			$bucket_id = SQL_INSERT_ID();

			echo json_encode(array('result'=>$sth, 'bucket_id'=>$bucket_id, 'bucket_name'=>$_POST['bucket_name']));
		}
		else {
			echo json_encode("No bucket sent");
		}
	}
	elseif($_POST['action'] == "delete_bucket"){
		if(isset($_POST['bucket_id'])){

			// TODO check if buckets have connected contacts
			$sth = SQL_QUERY("delete from contact_buckets where bucket_id=".SQL_CLEAN($_POST["bucket_id"]));

			// TODO Before delete all status, for each connected status delete child sub status

			echo $sth;
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "edit_bucket"){
		if(isset($_POST['bucket_id'])){
			$sth = SQL_QUERY("update contact_buckets set bucket_name='".SQL_CLEAN($_POST['bucket_name'])."' where bucket_id=".SQL_CLEAN($_POST['bucket_id']));
			
			echo json_encode(array("text" => "Success", "sent" => $_POST));
		}
		else {
			echo json_encode("No id sent");
		}
	}
	elseif($_POST['action'] == "change_bucket_dashboard"){
		if(isset($_POST['bucket_id'])){
			$is_dashboard = 0;
			if ($_POST['value'] == "true") 
				$is_dashboard = 1;
			$sth = SQL_QUERY("update contact_buckets set is_dashboard=".$is_dashboard." where bucket_id=".SQL_CLEAN($_POST['bucket_id']));
			
			echo json_encode(array("text" => "Success", "sent" => $_POST));
		}
		else {
			echo json_encode("No id sent");
		}
	}
	else {
		echo json_encode("Something is wrong");
	}

}

exit;

	
?>