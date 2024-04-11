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

if(isset($_POST['action']) && ($_POST['action'] == 'allcol')){
	// Check if settings already saved
	$sth = SQL_QUERY("select * from company_page_settings 
		where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
		limit 1
		");

	if (SQL_NUM_ROWS($sth) != 0) {
		// if data exists update
		$sth = SQL_QUERY("Update company_page_settings set logo='".SQL_CLEAN($_POST['logo']).
			"', site_address='".SQL_CLEAN($_POST['site_address']).
			"', facebook='".SQL_CLEAN($_POST['facebook']).
			"', twitter='".SQL_CLEAN($_POST['twitter']).
			"', gmail='".SQL_CLEAN($_POST['gmail']).
			"', instagram='".SQL_CLEAN($_POST['instagram']).
			"', about_us='".SQL_CLEAN($_POST['about_us']).
			"', footer_line='".SQL_CLEAN($_POST['footer_line']).
			"' where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'"
		);
	}
	else {
		// if data doesnt exists add
		$sth = SQL_QUERY("
			insert into 
			company_page_settings set 
			company_id='".SQL_CLEAN($_SESSION['user']['company_id']).
			"', logo='".SQL_CLEAN($_POST['logo']).
			"', site_address='".SQL_CLEAN($_POST['site_address']).
			"', facebook='".SQL_CLEAN($_POST['facebook']).
			"', twitter='".SQL_CLEAN($_POST['twitter']).
			"', gmail='".SQL_CLEAN($_POST['gmail']).
			"', instagram='".SQL_CLEAN($_POST['instagram']).
			"', about_us='".SQL_CLEAN($_POST['about_us']).
			"', footer_line='".SQL_CLEAN($_POST['footer_line'])."'"
		);
	}

	echo json_encode(true);
}
else if(isset($_POST['action']) && ($_POST['action'] == 'percol')){

	$column = SQL_CLEAN($_POST['column']);

	SQL_QUERY("Update company_page_settings set $column='".SQL_CLEAN($_POST['value'])."' where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));

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