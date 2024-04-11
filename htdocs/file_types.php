<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(TRUE);

$sth = SQL_QUERY("select * from file_types where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and is_deleted=0 order by sequence, name ");
$file_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
    $file_types[] = $data;
}

$smarty->assign('file_types', $file_types);

$smarty->assign('footer_js', 'includes/footers/file_types_footer.tpl');
$smarty->display('file_types.tpl');

?>