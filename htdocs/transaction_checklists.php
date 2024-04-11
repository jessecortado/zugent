<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('transactions');

auth(true);

// temporarily disable
// if($_SESSION['user']['is_admin'] == 0)
// header("location: /dashboard.php");

$sth = SQL_QUERY("select tc.*, CONCAT(u1.first_name,' ',u1.last_name) as created_by, CONCAT(u2.first_name,' ',u2.last_name) as modified_by from transaction_checklists as tc
					left join users as u1 on u1.user_id=tc.created_user_id 
					left join users as u2 on u2.user_id=tc.modified_user_id 
					where tc.is_active=1 and tc.company_id=".SQL_CLEAN($_SESSION['user']['company_id']));

$checklists = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$checklists[] = $data;
}

$sth = SQL_QUERY("select tc.*, CONCAT(u1.first_name,' ',u1.last_name) as created_by, CONCAT(u2.first_name,' ',u2.last_name) as modified_by from transaction_checklists as tc
					left join users as u1 on u1.user_id=tc.created_user_id 
					left join users as u2 on u2.user_id=tc.modified_user_id 
					where tc.is_active=0 and tc.company_id=".SQL_CLEAN($_SESSION['user']['company_id']));

$inactive_checklists = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$inactive_checklists[] = $data;
}

$smarty->assign("company_id", $_SESSION['user']['company_id']);
$smarty->assign("checklists", $checklists);
$smarty->assign("inactive_checklists", $inactive_checklists);

$smarty->assign("footer_js", 'includes/footers/transaction_checklists_footer.tpl');
$smarty->display('transaction_checklists.tpl');

?>
