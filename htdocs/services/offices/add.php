<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xof7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['name'])) {

	$sth = SQL_QUERY("insert into offices set is_active=1, 
						name='".SQL_CLEAN($_POST['name']).
						"', phone_office='".SQL_CLEAN($_POST['phone_office']).
						"', phone_fax='".SQL_CLEAN($_POST['phone_fax']).
						"', street_address='".SQL_CLEAN($_POST['street_address']).
						"', state='".SQL_CLEAN($_POST['state']).
						"', city='".SQL_CLEAN($_POST['city']).
						"', zip='".SQL_CLEAN($_POST['zip']).
						"', company_id=".$_SESSION['user']['company_id']
					);

	$office_id = SQL_INSERT_ID();

	// Add office log
	add_user_log("Added an office (".$office_id.")", "offices", array("importance" => "Info", "action" => "Add") );


	$_SESSION['user'][$column] = SQL_CLEAN($_POST['value']);

	header("location: /offices.php");
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