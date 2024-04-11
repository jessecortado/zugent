<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('transactions');

auth(true);

$sth = SQL_QUERY("select * from transaction_type where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."");
$transaction_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$transaction_types[] = $data;
}

$sth = SQL_QUERY("select * from transaction_status where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."");
$transaction_status = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$transaction_status[] = $data;
}

$smarty->assign('transaction_status', $transaction_status);
$smarty->assign('transaction_types', $transaction_types);

$smarty->assign('footer_js', 'includes/footers/transaction_variables_footer.tpl');
$smarty->display('transaction_variables.tpl');