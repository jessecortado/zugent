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


if(isset($_POST['menu_id'])){

	$sth = SQL_QUERY("Delete from company_menus 
		where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
		and menu_id='".SQL_CLEAN($_POST['menu_id'])."'");

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