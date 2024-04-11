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

// temporarily disable
// if($_SESSION['user']['is_admin'] == 0)
// header("location: /dashboard.php");

if(isset($_GET['id'])) {


	$sth = SQL_QUERY("select pl.* from pool_leads as pl 
		left join users as u on pl.user_id=u.user_id 
		where (u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
		and u.is_admin=1 and u.is_superadmin=1) 
		and pl.pool_id=".SQL_CLEAN($_GET['id'])." 
		and pl.is_active=1  
	");

	// if(SQL_NUM_ROWS($sth) == 0)
	// 	exit;

	$pool_leads = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$data['phone_0'] = check_number($data['phone_0']);
		$pool_leads[] = $data;
	}

	$filter = array();

	$sth = SQL_QUERY("select distinct p.city, p.county from pool_leads as p  
		left join users as u on p.user_id=u.user_id 
		where u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
		and p.pool_id=".SQL_CLEAN($_GET['id'])." 
		and p.is_active=1  
		order by p.county, p.city");

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$filter[]['name'] = $data['county']. " - " .$data['city'];
	}
	

	$sth = SQL_QUERY("select * from pools where pool_id=".SQL_CLEAN($_GET['id']));

	$pool = SQL_ASSOC_ARRAY($sth);

	$_SESSION['pool'] = $pool;

	$smarty->assign('filter', $filter);
	$smarty->assign('pool', $pool);
	$smarty->assign('pool_leads', $pool_leads);
	$smarty->assign('pool_leads_json', json_encode($pool_leads));
	$smarty->assign('id', $_GET['id']);
	$smarty->assign("footer_js", "includes/footers/pool_leads_list_footer.tpl");
	$smarty->display('pool_leads_list.tpl');

}
else
	exit;

?>
