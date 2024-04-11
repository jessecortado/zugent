<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('offices');

auth(true);

// $sth = SQL_QUERY("select o.*, 
// 					oo.office_rel_office_id as is_mls 
// 					from offices as o 
// 					left join office_rel_offices as oo on o.office_id=oo.office_id 
// 					where o.is_active=1 and o.company_id=".SQL_CLEAN($_SESSION['user']['company_id']).
// 					" order by o.name ");
// $active_offices = array();
// $ctr = 1;
// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$data['count'] = $ctr;
// 	$active_offices[] = $data;
// 	$ctr++;
// }

// $sth = SQL_QUERY("select o.* from offices as o where o.is_active=0 and o.company_id=".SQL_CLEAN($_SESSION['user']['company_id']).
// 					" order by o.name");
// $inactive_offices = array();
// $ctr = 1;
// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$data['count'] = $ctr;
// 	$inactive_offices[] = $data;
// 	$ctr++;
// }

$sth = SQL_QUERY("select distinct o.* , 
					oo.office_id as is_mls 
					from offices o 
					left join office_rel_offices oo on o.office_id=oo.office_id 
					where o.company_id=".SQL_CLEAN($_SESSION['user']['company_id']).
					" order by name");
$all_offices = array();
$ctr = 1;
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['count'] = $ctr;
	$all_offices[] = $data;
	$ctr++;
}

$sth = SQL_QUERY("select m.* from mls m 
					left join company_rel_mls as cm on m.mls_id=cm.mls_id 
					where cm.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
					order by m.mls_name");
$mls = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$mls[] = $data;
}

// $smarty->assign('active_offices', $active_offices);
// $smarty->assign('inactive_offices', $inactive_offices);
$smarty->assign('all_offices', $all_offices);
$smarty->assign('mls', $mls);
$smarty->assign('is_mls', count($mls));

$smarty->display('offices.tpl');
