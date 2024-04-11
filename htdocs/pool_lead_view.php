<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('pools');

auth();

// phpinfo();

// die(date("Y-m-d H:i:s"));
// Workaround for strange bug where a notice appears for each time
// the pool table or pool related tables are used
error_reporting(E_ERROR | E_WARNING | E_PARSE);

if(isset($_GET['id'])) {

	$sth = SQL_QUERY("select p.*, CONCAT(u.first_name,' ',u.last_name) as added_by from pool_leads as p  
		left join users as u on p.user_id=u.user_id 
		where u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
		and p.pool_lead_id=".SQL_CLEAN($_GET['id'])."");

	if(SQL_NUM_ROWS($sth) == 0)
		header("location: /dashboard.php?code=1xpl7");
		// exit;

	$lead = SQL_ASSOC_ARRAY($sth);

	$raw_data = json_decode($lead['raw_data'], true);

	$lead['raw_data'] = strip_tags($lead['raw_data']);
	$lead['raw_data'] = str_replace("\n","<BR/>",$lead['raw_data']);
	if (strlen($lead['raw_data']) > 500) {
		$start = substr($lead['raw_data'], 0, 500);
		$end = substr($lead['raw_data'],500,strlen($lead['raw_data']));
		$lead['raw_data_start'] = $start;
		$lead['raw_data_end'] = $end;
	}
	for ($i = 0; $i < 10; $i++) {
		$lead['phone_'.$i] = check_number($lead['phone_'.$i]);
	}

	$contact_log = array();

	$sth = SQL_QUERY("select p.*, pcm.contact_method, CONCAT(u.first_name, ' ', u.last_name) as username from pool_lead_contact_log as p 
						left join pool_contact_methods as pcm on p.pool_contact_method_id=pcm.pool_contact_method_id 
						left join users as u on p.user_id=u.user_id 
						where p.pool_lead_id=".SQL_CLEAN($_GET['id'])." 
						order by p.date_created DESC
		");

	while($data = SQL_ASSOC_ARRAY($sth)) {
		$contact_log[] = $data;
	}
	
	// die (var_dump($raw_data));
	
	$smarty->assign('lead', $lead);
	$smarty->assign('raw_data', $raw_data);
	$smarty->assign('id', $_GET['id']);
	$smarty->assign('contact_log', $contact_log);
	$smarty->display('pool_lead_view.tpl');

}

?>