<?php

// Get User Email Templates
$sth = SQL_QUERY("select * from user_email_templates 
	where user_id = '".$_SESSION['user_id']."' 
	and is_deleted = 0 and is_email_type = 1");

$user_email_templates = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$user_email_templates[] = $data;
}

$smarty->assign("user", $_SESSION['user']);
$smarty->assign("user_email_templates", $user_email_templates);

?>