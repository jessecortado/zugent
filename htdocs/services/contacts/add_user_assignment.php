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

if(isset($_POST['user_id'])){

	$date = gmdate("Y-m-d H:i:s");

	$sth = SQL_QUERY("insert into contacts_rel_users set ".
		"is_primary=0".
		", user_id=".SQL_CLEAN($_POST["user_id"]).
		", contact_id=".SQL_CLEAN($_POST["contact_id"]).
		", date_assigned='".$date.
		"', assigned_by_user_id=".SQL_CLEAN($_SESSION["user"]["user_id"])
	);

	$user_id = SQL_INSERT_ID();

	// Add user contact log
	add_user_log("Assigned a new user (".$_POST['user_id'].") to contact (".$_POST['contact_id'].")", "contacts", array("importance" => "Info", "action" => "Add") );

	
	$body = $_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." assigned you to a new contact.";
	$body .= "\nClick <a href='".$_SERVER['HTTP_HOST']."/contacts_edit.php?id=".$_POST['contact_id']."'>here</a> to view this contact.";

	$sth = SQL_QUERY("select * from users where user_id=".SQL_CLEAN($_POST['user_id']));
	$data = SQL_ASSOC_ARRAY($sth);

	send_message("support@ruopen.com", 
		array($data['email'], "juncalpito@zugent.com"), 
		"A Contact Has Been Assigned To You", 
		$body);

	$body = $_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." assigned you to a new contact.";

	// id, title, notification, url_action
	add_notification($_POST['user_id'], "Newly Assigned Contact", $body, "/contacts_edit.php?id=".$_POST['contact_id']);

	$sth3 = SQL_QUERY("select cru.*, u.first_name, u.last_name, u.company_id from contacts_rel_users as cru left join users as u on u.user_id = cru.user_id 
		where cru.contact_id=".SQL_CLEAN($_POST["contact_id"])." and cru.contact_user_id=".SQL_CLEAN($user_id)." and cru.is_deleted=0 limit 1");

	$recently_added_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
	 	$recently_added_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recently_added_data));
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