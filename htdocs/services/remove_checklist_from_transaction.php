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

$result = SQL_QUERY("
	delete from transaction_rel_checklists where transaction_id=".SQL_CLEAN($_POST['transaction_id'])." and checklist_id=".SQL_CLEAN($_POST['checklist_id']));


// Add transaction log
add_user_log("Removed checklist (".$_POST['checklist_id'].") from transaction (".$_POST['transaction_id'].")", "transaction", array("importance" => "Info", "action" => "Delete") );

print "1";
exit;

	
?>