<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xbuc7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['bucket_name'])){
	$sth = SQL_QUERY("
			insert into 
				contact_buckets set  
				is_dashboard=0, 
				bucket_name='".SQL_CLEAN($_POST['bucket_name'])."', company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
		");

	$bucket_id = SQL_INSERT_ID();

	// Add bucket log
	add_user_log("Added a bucket (".$bucket_id.")", "bucket", array("importance" => "Info", "action" => "Add") );


	echo json_encode(array('msg'=>true, 'bucket_id'=>$bucket_id, 'bucket_name'=>$_POST['bucket_name']));
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xbuc7");
	}
}

?>