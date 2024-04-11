<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xft7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'file_types',
	"main_table_field" => 'file_type_id',
	"main_field_value" => $_POST["file_type_id"],
	"table_join_name" => 'users',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t1.is_deleted!" => '1',
		"t2.is_active" => '1'
		)
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['file_type_id'])){

	$sth = SQL_QUERY("update file_types set name='".SQL_CLEAN($_POST['name'])."' where file_type_id=".SQL_CLEAN($_POST["file_type_id"]));

	// Add file type log
	add_user_log("Updated a file_type (".$_POST['file_type_id'].")", "file_types", array("importance" => "Info", "action" => "Update") );

	echo json_encode(true);
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xft7");
	}
}

?>