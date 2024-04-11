<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('bulk_email');

auth(false, true);

$sth = SQL_QUERY("select * from bulk_send_log as bsl 
	left join bulk_templates as bt on bsl.bulk_template_id=bt.bulk_template_id 
	where bsl.user_id='".SQL_CLEAN($_SESSION['user_id'])."'");

$email_logs = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['filters'] = json_decode($data['filters'], true);
	$email_logs[] = $data;
}

$smarty->assign('user_id', $_SESSION['user_id']);
$smarty->assign('email_logs', $email_logs);
// $smarty->assign('company_templates', $company_templates);
// $smarty->assign('footer_js', 'includes/footers/bulk_email_template_footer.tpl');
$smarty->display('bulk_email_history.tpl');

?>