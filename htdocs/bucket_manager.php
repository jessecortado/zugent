<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(true);

// temporarily disable
// if($_SESSION['user']['is_admin'] == 0)
// header("location: /dashboard.php");

$sth = SQL_QUERY("select * from contact_buckets where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$buckets = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$buckets[] = $data;
}

$sth = SQL_QUERY("select * from contact_bucket_tags 
	where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' 
	order by tag_name asc
	");
$bucket_tags = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$bucket_tags[] = $data;
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

$smarty->assign("company_id", $_SESSION['user']['company_id']);
$smarty->assign("buckets", $buckets);
$smarty->assign("bucket_tags", $bucket_tags);
$smarty->assign("tags", $tags);

$smarty->assign("footer_js", 'includes/footers/bucket_manager_footer.tpl');
$smarty->display('bucket_manager.tpl');

?>
