<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xbuc7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'contact_buckets',
	"main_table_field" => 'bucket_id',
	"main_field_value" => $_POST["bucket_id"],
	"table_join_name" => 'users',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t2.is_active" => '1'
		)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['bucket_id'])){
	$sth = SQL_QUERY("update contact_buckets set bucket_name='".SQL_CLEAN($_POST['bucket_name'])."' where bucket_id=".SQL_CLEAN($_POST['bucket_id']));
	
	// Add bucket log
	add_user_log("Edited a bucket (".$_POST['bucket_id'].")", "bucket", array("importance" => "Info", "action" => "Add") );
	
	echo json_encode(true);
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