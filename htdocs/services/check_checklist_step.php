<?php
ob_start();
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
	
	$sth_users = SQL_QUERY("select c.*, u.email as user_email, CONCAT(u.first_name,' ', u.last_name) as user_full_name, CONCAT(c.first_name,' ', c.last_name) as contact_full_name  
						from contacts_rel_users as cru 
						left join contacts as c on c.contact_id=cru.contact_id
						left join users as u on u.user_id=cru.user_id 
						where cru.contact_id='".SQL_CLEAN($transaction['contact_id'])."' 
						and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
						and cru.is_deleted=0");

	while($data = SQL_ASSOC_ARRAY($sth_users)) {
		$body = "An update to a checklist your contact (".$data['contact_full_name'].") is attached to has been made.\nYou can view the change <a href='crm.ruopen.com/transaction/".$transaction['transaction_id']."'>here</a>.";

		echo send_message("support@ruopen.com", 
			array($data['user_email'], "support@ruopen.com"), 
			"A change to a transaction checklist has been made", 
			$body);
	}
}

$sth = SQL_QUERY("select * from transaction_step_log where checklist_step_id=".SQL_CLEAN($_POST['checklist_step_id']));

if (SQL_NUM_ROWS($sth) == 0) {
	if (isset($_POST['admin_checked'])) {
		SQL_QUERY("
			insert into transaction_step_log set 
				date_admin_checked=NOW()"."
				, admin_user_id='".SQL_CLEAN($_SESSION['user_id'])."'
				, admin_checked='".SQL_CLEAN($_POST['admin_checked'])."'
				, checklist_step_id='".SQL_CLEAN($_POST['checklist_step_id'])."'
				, transaction_id='".SQL_CLEAN($_POST['transaction_id'])."'
		");
	} 
	elseif (isset($_POST['agent_checked'])) {
		SQL_QUERY("
			insert into transaction_step_log set 
				date_agent_checked=NOW()"."
				, agent_user_id='".SQL_CLEAN($_SESSION['user_id'])."'
				, agent_checked='".SQL_CLEAN($_POST['agent_checked'])."'
				, checklist_step_id='".SQL_CLEAN($_POST['checklist_step_id'])."'
				, transaction_id='".SQL_CLEAN($_POST['transaction_id'])."'
		");

		send_users_email();
	}
}
else {
	if (isset($_POST['admin_checked'])) {
		SQL_QUERY("
			update transaction_step_log set 
				date_admin_checked=NOW()"."
				, admin_user_id='".SQL_CLEAN($_SESSION['user_id'])."'
				, admin_checked='".SQL_CLEAN($_POST['admin_checked'])."'
				, transaction_id='".SQL_CLEAN($_POST['transaction_id'])."' 
				where checklist_step_id='".SQL_CLEAN($_POST['checklist_step_id'])."'
		");
	} 
	elseif (isset($_POST['agent_checked'])) {
		SQL_QUERY("
			update transaction_step_log set 
				date_agent_checked=NOW()"."
				, agent_user_id='".SQL_CLEAN($_SESSION['user_id'])."'
				, agent_checked='".SQL_CLEAN($_POST['agent_checked'])."'
				, transaction_id='".SQL_CLEAN($_POST['transaction_id'])."' 
				where checklist_step_id='".SQL_CLEAN($_POST['checklist_step_id'])."'
		");

		send_users_email();

	}
}

// echo 1;


header("location: /transaction/".$_POST['transaction_id']);

exit;

	
?>