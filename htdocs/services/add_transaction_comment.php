<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

$sth = SQL_QUERY("select t.* 
					from transactions as t 
					left join users as u on u.user_id=t.user_id 
					where t.transaction_id=".SQL_CLEAN($_POST['id'])." and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])
				);

if (SQL_NUM_ROWS($sth) == 0) {
	print "0";
	exit;
}

SQL_QUERY("
	insert into transaction_comments 
	(
		user_id
		, transaction_id
		, date_created
		, comment
	) values (
		'".SQL_CLEAN($_SESSION['user_id'])."'
		, '".SQL_CLEAN($_POST['id'])."'
		, NOW()
		, '".SQL_CLEAN($_REQUEST['comment'])."'
	)
");

print "1";
exit;

	
?>