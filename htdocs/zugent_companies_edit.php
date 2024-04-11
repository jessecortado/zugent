<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(true);

if ( $_SESSION['user']['company_id'] !== "1" )
    header("location: /dashboard");


$GET_URI = explode('/', $_SERVER['REQUEST_URI']);

$sth = SQL_QUERY("select * from companies 
	where company_id='".SQL_CLEAN($GET_URI[3])."' 
    limit 1");
    
$company = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$company[] = $data;
}


if(isset($_POST['company_id'])) {
	// UPDATE COMPANY
	$sth = SQL_QUERY("update companies set 
		company_name='".SQL_CLEAN($_POST['company_name'])."', 
		email_footer_line_1='".SQL_CLEAN($_POST['email_footer_line_1'])."', 
		email_footer_line_2='".SQL_CLEAN($_POST['email_footer_line_2'])."', 
		phone_office='".SQL_CLEAN($_POST['phone_office'])."', 
		city='".SQL_CLEAN($_POST['city'])."', 
		street_address='".SQL_CLEAN($_POST['street_address'])."', 
		state='".SQL_CLEAN($_POST['state'])."', 
		zip='".SQL_CLEAN($_POST['zip'])."', 
		timezone='".SQL_CLEAN($_POST['timezone'])."', 
		phone_fax='".SQL_CLEAN($_POST['phone_fax'])."', 
		is_free='".SQL_CLEAN($_POST['is_free'])."', 
		date_free_ends='".SQL_CLEAN($_POST['date_free_ends'])."', 
		discount_per_user='".SQL_CLEAN($_POST['discount_per_user'])."', 
		has_transactions='".SQL_CLEAN($_POST['has_transactions'])."', 
		has_drive='".SQL_CLEAN($_POST['has_drive'])."', 
		has_pools='".SQL_CLEAN($_POST['has_pools'])."', 
		has_bulk_email='".SQL_CLEAN($_POST['has_bulk_email'])."', 
		has_referrals='".SQL_CLEAN($_POST['has_referrals'])."', 
		has_social='".SQL_CLEAN($_POST['has_social'])."', 
		has_broker_page='".SQL_CLEAN($_POST['has_broker_page'])."', 
		has_campaigns='".SQL_CLEAN($_POST['has_campaigns'])."', 
		has_offices='".SQL_CLEAN($_POST['has_offices'])."' 
		where company_id='".SQL_CLEAN($_POST['company_id'])."'");
	
	$sth = SQL_QUERY("select * from companies 
		where company_id='".SQL_CLEAN($_POST['company_id'])."' 
	    limit 1");
	    
	$company = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$company[] = $data;
	}

	$smarty->assign('display_message', TRUE);

}

$smarty->assign('timezones', get_timezones());
$smarty->assign('company', $company);
$smarty->assign("footer_js", "includes/footers/zugent_companies_edit.tpl");
$smarty->display('zugent_companies_edit.tpl');

?>