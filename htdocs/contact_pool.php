<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('pools');

auth();

// Workaround for strange bug where a notice appears for each time
// the pool table or pool related tables are used
error_reporting(E_ERROR | E_WARNING | E_PARSE);

$sth = SQL_QUERY("select p.*, u.first_name, u.last_name, COUNT(pl.pool_lead_id) as leads_count from pools as p  
	left join users as u on p.user_id=u.user_id 
	left join pool_leads as pl on p.pool_id=pl.pool_id 
	where u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
	and p.share_level!=".SQL_CLEAN(1)." 
	and p.share_level!=".SQL_CLEAN(0)." 
	and u.user_id!=".SQL_CLEAN($_SESSION['user']['user_id'])." 
	group by p.pool_id 
	order by p.date_updated DESC"); 

$contact_pool = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$contact_pool[] = $data;
}

$sth = SQL_QUERY("select p.*, u.first_name, u.last_name, COUNT(pl.pool_lead_id) as leads_count from pools as p  
	left join users as u on p.user_id=u.user_id 
	left join pool_leads as pl on p.pool_id=pl.pool_id 
	where p.user_id=".SQL_CLEAN($_SESSION['user']['user_id'])." 
	group by p.pool_id 
	order by p.date_updated DESC"); 

$my_pools = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$my_pools[] = $data;
}

// die(var_dump($contact_pool));

$smarty->assign('contact_pool', $contact_pool);
$smarty->assign('my_pools', $my_pools);
$smarty->assign("footer_js", "includes/footers/contact_pool_footer.tpl");
$smarty->display('contact_pool.tpl');
	
?>