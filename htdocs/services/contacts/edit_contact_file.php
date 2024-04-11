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

if(isset($_POST['contact_file_id'])){

	$date = gmdate("Y-m-d H:i:s");

	$sth = SQL_QUERY("update contact_files set ".
		"file_type_id=".SQL_CLEAN($_POST['file_type_id']).
		", file_name='".SQL_CLEAN($_POST['file_name']).
		"' where contact_file_id=".SQL_CLEAN($_POST['contact_file_id']).
		" and contact_id=".SQL_CLEAN($_POST['contact_id'])
		);

	// Add contact log (Edit)
	add_user_log("Updated a contact file (".$_POST['contact_file_id'].")", "contacts", array("importance" => "Info", "action" => "Update") );

	$sth3 = SQL_QUERY("select cf.*, cft.name as file_type_name from contact_files as cf 
		left join file_types as cft on cft.file_type_id = cf.file_type_id 
		where cf.contact_id=".SQL_CLEAN($_POST['contact_id'])." and cf.contact_file_id=".SQL_CLEAN($_POST['contact_file_id'])." and cf.is_deleted=0 limit 1");

	$recently_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
	 	$recently_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recently_data));
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