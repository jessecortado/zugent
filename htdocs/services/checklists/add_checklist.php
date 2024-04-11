<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xts7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['checklist_name'])){

	$date = gmdate("Y-m-d H:i:s");

	$sth = SQL_QUERY("
			insert into 
				transaction_checklists set 
				checklist_name='".SQL_CLEAN($_POST['checklist_name'])."', 
				date_added='".SQL_CLEAN($date)."', 
				created_user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."', 
				company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
		");

	$checklist_id = SQL_INSERT_ID();
	
	// Add checklist log
	add_user_log("Added a checklist (".$checklist_id.")", "checklist", array("importance" => "Info", "action" => "Add") );

	$sth3 = SQL_QUERY("select tc.*, CONCAT(u1.first_name,' ',u1.last_name) as created_by, CONCAT(u2.first_name,' ',u2.last_name) as modified_by from transaction_checklists as tc
					left join users as u1 on u1.user_id=tc.created_user_id 
					left join users as u2 on u2.user_id=tc.modified_user_id 
					where tc.is_active=1 and tc.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."  and tc.checklist_id=".SQL_CLEAN($checklist_id)." limit 1");

	$recently_added_data = array();

	while($data = SQL_ASSOC_ARRAY($sth3)) {
		$recently_added_data[] = $data;
	}

	echo json_encode(array('msg'=>$sth, 'data'=>$recently_added_data));
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xts7");
	}
}

?>