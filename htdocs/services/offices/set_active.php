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

	$sth = SQL_QUERY("update offices set is_active='".SQL_CLEAN($_POST['is_active'])."' where office_id=".SQL_CLEAN($_POST['office_id']));

	// Add office log
	add_user_log("Set an office to is_active=".$_POST['is_active']." (".$_POST['office_id'].")", "offices", array("importance" => "Info", "action" => "Status") );

	echo json_encode(true);

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