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
	"main_field_value" => $_POST['bucket_id'],
	"table_join_name" => 'users',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.user_id"    => $_SESSION['user']['user_id'],
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t2.is_active"  => '1'
	)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['bucket_id'])){

	$sth1 = SQL_QUERY("select * from contacts where bucket_id=".SQL_CLEAN($_POST['bucket_id'])." and company_id=".SQL_CLEAN($_SESSION['user']['company_id']));

	$sth2 = SQL_QUERY("select * from contact_bucket_tags where bucket_id='".SQL_CLEAN($_POST['bucket_id'])."'");

	$tag_ids = array();

	if (SQL_NUM_ROWS($sth2) > 0) {
		while ($data = SQL_ASSOC_ARRAY($sth2)) {
			$tag_ids[] = $data['bucket_tag_id'];
		}
	}

	// TODO check if bucket has tags
	if (SQL_NUM_ROWS($sth1) > 0 && SQL_NUM_ROWS($sth2) > 0) {
		$msg = "You won't be able to revert this!<br>";
		$msg .= "Bucket is being used by ".SQL_NUM_ROWS($sth1)." contact/s.<br>";
		$msg .= "and has ".SQL_NUM_ROWS($sth2)." tag/s.<br>";
		$msg .= "Please confirm if you still want to delete.";
		$has_tags = true;
	}
	else if (SQL_NUM_ROWS($sth1) > 0 && SQL_NUM_ROWS($sth2) == 0) {
		$msg = "You won't be able to revert this!<br>";
		$msg .= "Bucket is being used by ".SQL_NUM_ROWS($sth1)." contact/s.<br>";
		$msg .= "Please confirm if you still want to delete.";
		$has_tags = false;
	}
	else if (SQL_NUM_ROWS($sth1) == 0 && SQL_NUM_ROWS($sth2) > 0) {
		$msg = "You won't be able to revert this!<br>";
		$msg .= "Bucket has ".SQL_NUM_ROWS($sth2)." tags.<br>";
		$msg .= "Please confirm if you still want to delete.";
		$has_tags = true;
	}
	else {
		$msg = "You won't be able to revert this!<br>";
		$msg .= "Please confirm if you still want to delete.";
		$has_tags = false;
	}

	echo json_encode(array("connected"=>true, "msg"=>$msg, "tag_ids"=>$tag_ids, "has_tags"=>$has_tags));
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