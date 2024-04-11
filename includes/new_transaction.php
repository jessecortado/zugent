<?php

// User Contacts
$sth = SQL_QUERY("select c.contact_id, concat(c.first_name,' ',c.last_name) as client from contacts as c 
	left join contacts_rel_users as cru on cru.contact_id=c.contact_id 
	where c.company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
	cru.user_id = '".SQL_CLEAN($_SESSION['user_id'])."' order by c.contact_id asc
	");
$user_contacts = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$user_contacts[] = $data;
}

// Users Dropdown - Changes User Contacts
$sth = SQL_QUERY("select * from users where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$company_users = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$company_users[] = $data;
}

// For Buckets
$sth = SQL_QUERY("select * from contact_buckets where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$buckets = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$buckets[] = $data;
}

// Transaction Types
$sth = SQL_QUERY("select * from transaction_type where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$transaction_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$transaction_types[] = $data;
}

	// echo "<pre>";
	// print_r($transaction_types);
	// echo "</pre>";
	// die("TEST");

// Transaction Status
$sth = SQL_QUERY("select * from transaction_status where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$transaction_status = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$transaction_status[] = $data;
}


$smarty->assign("user", $_SESSION['user']);
$smarty->assign("user_contacts", $user_contacts);
$smarty->assign("company_users", $company_users);
$smarty->assign("buckets", $buckets);
$smarty->assign("transaction_types", $transaction_types);
$smarty->assign("transaction_status", $transaction_status);

?>