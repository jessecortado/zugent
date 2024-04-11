<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth();

$sth = SQL_QUERY("select distinct filename, media_url, user_id from user_media_elements where type='frame' and user_id=" . SQL_CLEAN($_SESSION['user']['user_id']) . " order by filename ");
$frames = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
    $frames[] = $data;
}

$sth = SQL_QUERY("select distinct filename, media_url, user_id from user_media_elements where type='main' and user_id=" . SQL_CLEAN($_SESSION['user']['user_id']) . " order by filename ");
$images = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
    $images[] = $data;
}


$sth = SQL_QUERY("select m.* from mls m 
					left join company_rel_mls as cm on m.mls_id=cm.mls_id 
					where cm.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
					order by m.mls_name");
$mls = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$mls[] = $data;
}

// $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
$protocol = "http://";

$smarty->assign("host_url", $protocol.$_SERVER['HTTP_HOST']);

$smarty->assign("frames", $frames);
$smarty->assign("images", $images);
$smarty->assign("mls", $mls);
$smarty->display("media_generator.tpl");

?>

 <!-- <img src="working_media.php?img_1=assets/img/about-us-cover.jpg&img_2=assets/img/club_logo.png" alt="GD Library Example Image" > -->