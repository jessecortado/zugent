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
	"main_table_name" => 'offices',
	"main_table_field" => 'office_id',
	"main_field_value" => $_POST['office_id'],
	"table_join_name" => 'contacts',
	"table_join_field" => 'company_id',
	"additional_where" => array(
		"t1.company_id" => $_SESSION['user']['company_id'],
		"t2.contact_id" => $_POST['contact_id'],
		"t1.is_active" => '1'
		)
);

auth_process($data, $is_ajax, TRUE);

if (isset($_POST['office_id'])) {

	$sth = SQL_QUERY("insert into contact_rel_offices set 
						contact_id=".SQL_CLEAN($_POST['contact_id']).
						", office_id=".SQL_CLEAN($_POST['office_id']).""
					);
					
	$id = SQL_INSERT_ID();

	// Add office log
	add_user_log("Added a contact (".$_POST['contact_id'].") to an office (".$_POST['office_id'].")", "offices", array("importance" => "Info", "action" => "Add") );

	echo json_encode(array("result"=>$sth, "id"=>$id));
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