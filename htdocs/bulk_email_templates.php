<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('bulk_email');

auth(false, true);

$sth = SQL_QUERY("select * from bulk_templates where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'");

$personal_templates = array();
$company_templates = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	if($data['user_id'] == $_SESSION['user_id']) {
		$personal_templates[] = $data;
	}
	if($data['is_company_shared'] == 1) {
		$company_templates[] = $data;
	}
}

$smarty->assign('user_id', $_SESSION['user_id']);
$smarty->assign('personal_templates', $personal_templates);
$smarty->assign('company_templates', $company_templates);
$smarty->assign('footer_js', 'includes/footers/bulk_email_template_footer.tpl');
$smarty->display('bulk_email_templates.tpl');

?>