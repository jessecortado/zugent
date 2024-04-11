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
	"main_table_name" => 'contacts',
	"main_table_field" => 'contact_id',
	"main_field_value" => $_POST['contact_id'],
	"table_join_name" => 'contacts_rel_users',
	"table_join_field" => 'contact_id',
	"additional_where" => array(
		"t1.contact_id" => $_POST["contact_id"],
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.user_id" => $_SESSION['user']['user_id'],
		"t2.contact_id" => $_POST["contact_id"],
		"t2.is_deleted!" => '1'
		)
);

auth_process($data, $is_ajax);

if(isset($_POST['contact_id'])){

	// $sth = SQL_QUERY("
	// 	select 
	// 		* 
	// 	from contacts_rel_users 
	// 	where user_id='".SQL_CLEAN($_SESSION['user_id'])."' 
	// 	and is_deleted != 1 
	// 	and contact_id='".SQL_CLEAN($_POST['contact_id'])."' 
	// 	limit 1
	// ");

	// if (SQL_NUM_ROWS($sth) == 0) {
	// 	echo json_encode(false);
	// 	exit;
	// }

	SQL_QUERY("
		insert into contact_comments 
		(
			user_id
			, contact_id
			, date_added
			, comment
		) values (
			'".SQL_CLEAN($_SESSION['user_id'])."'
			, '".SQL_CLEAN($_POST['contact_id'])."'
			, NOW()
			, '".SQL_CLEAN($_POST['comment'])."'
		)
	");

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