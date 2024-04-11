<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('bulk_email');

auth(false, true);


$sth = SQL_QUERY("select * from bulk_templates 
	where is_active=1 and user_id='".SQL_CLEAN($_SESSION['user_id'])."' 
	or (company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
	and is_company_shared=1) 
	order by bulk_template_id asc
");

$email_templates = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$email_templates[] = $data;
}

// For autocomplete tags
$sth = SQL_QUERY("select distinct tag_name from contact_bucket_tags 
	where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' 
	order by tag_name asc
	");
$tags = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$tags[] = $data['tag_name'];
}

$smarty->assign('email_templates', $email_templates);
$smarty->assign("tags", $tags);
$smarty->assign('user', $_SESSION['user']);
$smarty->assign('footer_js', 'includes/footers/bulk_email_footer.tpl');
$smarty->display('bulk_email.tpl');

?>