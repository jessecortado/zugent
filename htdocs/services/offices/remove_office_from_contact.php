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
	"main_table_name" => 'contact_rel_offices',
	"main_table_field" => 'contact_rel_office_id',
	"main_field_value" => $_POST['contact_rel_office_id'],
	"table_join_name" => 'offices',
	"table_join_field" => 'office_id',
	"additional_where" => array(
		"t2.company_id" => $_SESSION['user']['company_id'],
		"t2.is_active" => '1'
		)
);

auth_process($data, $is_ajax, TRUE);

if (isset($_POST['contact_rel_office_id'])) {

	$sth = SQL_QUERY("Delete from contact_rel_offices where  
					contact_rel_office_id=".SQL_CLEAN($_POST['contact_rel_office_id'])
				);

	// Add office log
	add_user_log("Deleted a contact from an office (".$_POST['contact_rel_office_id'].")", "offices", array("importance" => "Info", "action" => "Delete") );


	echo json_encode(array("result"=>$sth));
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