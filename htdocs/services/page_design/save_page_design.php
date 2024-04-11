<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x0c7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
);

auth_process($data, $is_ajax, TRUE);

if(!empty($_POST['page_name'])){
	// Check if settings already saved
	$sth = SQL_QUERY("select * from pages 
		where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
		limit 1
		");

	if (SQL_NUM_ROWS($sth) != 0) {
		// if data exists update
		$sth = SQL_QUERY("Update pages set page_name='".SQL_CLEAN($_POST['page_name']).
			"', plain_code='".SQL_CLEAN($_POST['plain_code']).
			"', edittable_code='".SQL_CLEAN($_POST['edittable_code']).
			"' where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'"
		);
	}
	else {
		// if data doesnt exists add
		$sth = SQL_QUERY("
			insert into 
			pages set 
			page_name='".SQL_CLEAN($_POST['page_name']).
			"', plain_code='".SQL_CLEAN($_POST['plain_code']).
			"', edittable_code='".SQL_CLEAN($_POST['edittable_code']).
			"', company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'"
		);
	}

	echo json_encode(true);
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