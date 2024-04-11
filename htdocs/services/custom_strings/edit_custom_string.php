<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xcus7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'company_variables',
	"main_table_field" => 'company_variable_id',
	"main_field_value" => $_POST['id'],
	"table_join_name" => 'users',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.company_id" => $_SESSION['user']['company_id']
		)
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['value'])){

	$column = SQL_CLEAN($_POST['column']);

	$sth = SQL_QUERY("Update company_variables set $column='".SQL_CLEAN($_POST['value'])."' where company_variable_id=".SQL_CLEAN($_POST['id']));
	
	// Add company variable (Update)
	add_user_log("Updated a company variable (".$_POST['id'].")", "company_variables", array("importance" => "Info", "action" => "Update") );
	echo json_encode(true);
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xcus7");
	}
}

?>