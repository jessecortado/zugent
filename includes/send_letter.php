<?php

// Get User Letter Templates
$letter_temp = SQL_QUERY("select * from user_email_templates 
	where user_id = '".$_SESSION['user_id']."' 
	and is_deleted = 0 and is_letter_type = 1");

$user_letter_templates = array();

while ($data = SQL_ASSOC_ARRAY($letter_temp)) {
	$user_letter_templates[] = $data;
}

$smarty->assign("user_letter_templates", $user_letter_templates);
 
?>