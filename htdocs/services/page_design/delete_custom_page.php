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


if(isset($_POST['page_id'])){

	// echo "<pre>";
	// print_r($_POST);
	// echo "</pre>";
	// die("TESTING");

	// Delete Custom Page
	SQL_QUERY("delete from pages where page_id=".SQL_CLEAN($_POST["page_id"])." and company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
	
	// Check if has link on menus
	$sth = SQL_QUERY("select * from company_menus 
		where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
		and is_custom_page='1' 
		and menu_link='".SQL_CLEAN($_POST['page_name'])."' 
		limit 1
		");

	if (SQL_NUM_ROWS($sth) != 0) {
		$sth = SQL_QUERY("
			delete from 
			company_menus where 
			menu_link='".SQL_CLEAN($_POST['page_name'])."' 
			and company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'"
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