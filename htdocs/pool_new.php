<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('pools');

auth();

$sth = SQL_QUERY("select p.*, u.first_name, u.last_name from pools as p  
	left join users as u on p.user_id=u.user_id 
	where u.pool_id=".SQL_CLEAN($_GET['id']));

$pool = SQL_ASSOC_ARRAY($sth);

// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$contact_pool[] = $data;
// }

$smarty->assign('pool', $pool);
$smarty->display('pool_new.tpl');
	

	
?>