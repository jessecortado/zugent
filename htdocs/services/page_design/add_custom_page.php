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


if(isset($_POST['page_name'])){

	// echo "<pre>";
	// print_r($_POST);
	// echo "</pre>";
	// die("TESTING");
	
	// Check if settings already saved
	$sth = SQL_QUERY("select * from pages 
		where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
		and page_name='".SQL_CLEAN($$_POST['page_name'])."' 
		limit 1
		");

	if (SQL_NUM_ROWS($sth) == 0) {
		$sth = SQL_QUERY("
			insert into 
			pages set 
			page_name='".SQL_CLEAN($_POST['page_name']).
			"', company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'"
		);

		echo json_encode(array("msg"=>true, "page_name"=>$_POST['page_name']));
	}
	else {
		echo json_encode(array("msg"=>false));
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