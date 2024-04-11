<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xof7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'offices',
	"main_table_field" => 'office_id',
	"main_field_value" => $_POST['office_id'],
	"table_join_name" => 'users',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t2.is_active" => '1'
		)
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['office_id'])) {

	$column = SQL_CLEAN($_POST['column']);

	if ($column == 'all') {
		$sth = SQL_QUERY("Update offices set name='".SQL_CLEAN($_POST['name']).
			"', phone_office='".SQL_CLEAN($_POST['phone_office']).
			"', phone_fax='".SQL_CLEAN($_POST['phone_fax']).
			"', state='".SQL_CLEAN($_POST['state']).
			"', city='".SQL_CLEAN($_POST['city']).
			"', zip='".SQL_CLEAN($_POST['zip']).
			"' where office_id=".SQL_CLEAN($_POST['office_id'])
		);

		// Add office log
		add_user_log("Update an office (".$_POST['office_id'].")", "offices", array("importance" => "Info", "action" => "Update") );

		header("location: /offices.php");
	}
	else {
		$sth = SQL_QUERY("Update offices set $column='".SQL_CLEAN($_POST['value'])."' where office_id=".SQL_CLEAN($_POST['office_id']));
		echo json_encode(true);
	}
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xof7");
	}
}

?>