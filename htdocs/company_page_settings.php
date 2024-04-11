<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('broker_page');

auth();

// Company Page Settings
$sth = SQL_QUERY("select * from company_page_settings 
  where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
  limit 1
");

$settings_data = array();

if (SQL_NUM_ROWS($sth) != 0) {
	$settings_data = SQL_ASSOC_ARRAY($sth);
}

// Company Custom Pages
$sth2 = SQL_QUERY("select * from pages 
  where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
");

$custom_pages = array();

if (SQL_NUM_ROWS($sth2) != 0) {
	while ($data = SQL_ASSOC_ARRAY($sth2)) {
		$custom_pages[] = $data;
	}
}

// Company Menu
$sth3 = SQL_QUERY("select * from company_menus 
  where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
  order by menu_order ASC
");

$parent_menu = array();
$child_menu = array();

if (SQL_NUM_ROWS($sth3) != 0) {
	while ($data = SQL_ASSOC_ARRAY($sth3)) {
		if ($data['parent_id'] == '0') {
			$parent_menu[] = $data;
		}
		else {
			$child_menu[] = $data;
		}
	}

	$smarty->assign('parent_menu', $parent_menu);
	$smarty->assign('child_menu', $child_menu);
}
else {
	$smarty->assign('parent_menu', '');
	$smarty->assign('child_menu', '');
}

$smarty->assign('company_settings', $settings_data);
$smarty->assign('custom_pages', $custom_pages);
$smarty->assign('footer_js', 'includes/footers/company_page_settings_footer.tpl');

$smarty->display("company_page_settings.tpl");

?>