<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

require_once($_SERVER['SITE_DIR']."/includes/sub_pages.php");

$smarty->display('mls_feeds.tpl');

?>