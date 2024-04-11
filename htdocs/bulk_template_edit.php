<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('bulk_email');

auth(false, true);

if(isset($_GET['id'])) {

	$sth = SQL_QUERY("select * from bulk_templates where bulk_template_id='".SQL_CLEAN($_GET['id'])."' limit 1");

	$bulk_template = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$bulk_template[] = $data;
	}

	$smarty->assign('bulk_template', $bulk_template);
	$smarty->assign('footer_js', 'includes/footers/bulk_template_edit_footer.tpl');
	$smarty->display('bulk_template_edit.tpl');

}
else {
	header("location: /dashboard.php?code=1xbe7");
}

?>