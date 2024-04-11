<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

$sth = SQL_QUERY("select t.* 
					from transactions as t 
					left join users as u on u.user_id=t.user_id 
					where t.transaction_id=".SQL_CLEAN($_POST['transaction_id'])." and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])
				);

if (SQL_NUM_ROWS($sth) == 0) {
	print "0";
	exit;
}

function send_users_email() {
	$sth = SQL_QUERY("select t.* 
					from transactions as t 
					left join users as u on u.user_id=t.user_id 
					where t.transaction_id=".SQL_CLEAN($_POST['transaction_id'])." and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])
				);
	$transaction = SQL_ASSOC_ARRAY($sth);
	
	$sth_users = SQL_QUERY("select c.*, u.email as user_email, CONCAT(u.first_name,' ', u.last_name) as user_full_name, 			CONCAT(c.first_name,' ', c.last_name) as contact_full_name  
						from contacts_rel_users as cru 
						left join contacts as c on c.contact_id=cru.contact_id
						left join users as u on u.user_id=cru.user_id 
						where cru.contact_id='".SQL_CLEAN($transaction['contact_id'])."' 
						and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
						and cru.is_deleted=0");

	while($data = SQL_ASSOC_ARRAY($sth_users)) {
		$body = "A checklist has been added to your contact (".$data['contact_full_name'].").\nYou can view the change <a href='crm.ruopen.com/transaction/".$transaction['transaction_id']."'>here</a>.";

		send_message("support@ruopen.com", 
			array($data['user_email'], "support@ruopen.com"), 
			"A change to a transaction has been made", 
			$body);
	}
}

$result = SQL_QUERY("
	insert into transaction_rel_checklists 
	(
		created_user_id
		, transaction_id
		, checklist_id 
		, date_added
	) values (
		'".SQL_CLEAN($_SESSION['user_id'])."'
		, '".SQL_CLEAN($_POST['transaction_id'])."'
		, '".SQL_CLEAN($_POST['checklist_id'])."'
		, NOW()
	)
");

$id = SQL_INSERT_ID();

// Add transaction log
add_user_log("Added checklist (".$_POST['checklist_id'].") to transaction (".$_POST['transaction_id'].")", "transaction", array("importance" => "Info", "action" => "Add") );

send_users_email();


// echo $id;
echo json_encode(array("success"=>1, "id"=>$id));
// header("location: /transaction/".$_POST['transaction_id']);
exit;

	
?>