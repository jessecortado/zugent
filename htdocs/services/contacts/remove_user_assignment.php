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
	"main_field_value" => $_POST["contact_id"],
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

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['contact_user_id'])){

	$date = gmdate("Y-m-d H:i:s");

	$sth = SQL_QUERY("update contacts_rel_users set ".
		"is_primary=0".
		", is_deleted=1".
		", date_deleted='".$date.
		"', deleted_by_user_id=".SQL_CLEAN($_SESSION["user"]["user_id"]).
		" where contact_user_id=".SQL_CLEAN($_POST['contact_user_id'])
	);

	// Add contact log (Delete)
	add_user_log("Unassigned a user (".$_POST['contact_user_id'].")", "contacts", array("importance" => "Info", "action" => "Delete") );

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