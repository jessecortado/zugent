<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('campaigns');

auth(true);

$sth = SQL_QUERY("select * from company_variables where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."");
$custom_strings = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
    $custom_strings[] = $data;
}

$smarty->assign('custom_strings', $custom_strings);
$smarty->assign('footer_js', 'includes/footers/custom_strings_footer.tpl');

$smarty->display('custom_strings.tpl');