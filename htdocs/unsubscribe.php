<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");


function decrypt($sData) {
	$url_id = base64_decode($sData);
	$id = (double) $url_id / 845672.35;
	return $id;
}

if (isset($_GET['contact'])) {

	if (empty($_GET['contact'])) 
		header('location: https://'.$_SERVER['HTTP_HOST']);

	$contact_id = decrypt($_GET['contact']);

	SQL_QUERY("update contacts set is_unsubscribed = 1 where contact_id=".SQL_CLEAN($contact_id));

	$smarty->display('unsubscribe.tpl');

}
else {
	header('location: https://'.$_SERVER['HTTP_HOST']);
}

?>