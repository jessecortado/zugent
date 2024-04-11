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

SQL_QUERY("
	update transactions set 
		date_modified=NOW()"."
		, extended_data='".SQL_CLEAN($_POST['extended_data'])."' 
		where transaction_id=".SQL_CLEAN($_POST['transaction_id'])."
");

header("location: /transaction/".$_POST['transaction_id']);

exit;

	
?>