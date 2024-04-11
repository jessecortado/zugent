<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('transactions');

auth();

$sth = SQL_QUERY("select t.* 
					from transactions as t 
					left join users as u on u.user_id=t.user_id 
					where t.transaction_id=".SQL_CLEAN($_GET['id'])." and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])
				);

if (SQL_NUM_ROWS($sth) == 0) 
	exit;

if (isset($_GET['id'])) {

	$sth = SQL_QUERY("select * from transaction_type where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."");
	$transaction_types = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$transaction_types[] = $data;
	}

	$sth = SQL_QUERY("select * from transaction_status where company_id=".SQL_CLEAN($_SESSION['user']['company_id'])."");
	$transaction_status = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$transaction_status[] = $data;
	}

	$sth = SQL_QUERY("select tc.*, CONCAT(u1.first_name,' ',u1.last_name) as created_by, CONCAT(u2.first_name,' ',u2.last_name) as modified_by from transaction_checklists as tc
					left join users as u1 on u1.user_id=tc.created_user_id 
					left join users as u2 on u2.user_id=tc.modified_user_id 
					where tc.is_active=1 and tc.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and tc.checklist_id not in (select checklist_id from transaction_rel_checklists where transaction_id=".SQL_CLEAN($_GET['id']).")");

	$company_checklists = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$company_checklists[] = $data;
	}

	$sth = SQL_QUERY("select trc.transaction_rel_checklist_id, tc.*, CONCAT(u1.first_name,' ',u1.last_name) as created_by, CONCAT(u2.first_name,' ',u2.last_name) as modified_by from transaction_rel_checklists as trc 
						left join transaction_checklists as tc on trc.checklist_id=tc.checklist_id
						left join users as u1 on u1.user_id=tc.created_user_id 
						left join users as u2 on u2.user_id=tc.modified_user_id 
						where tc.is_active=1 and tc.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and trc.transaction_id=".SQL_CLEAN($_GET['id']));

	$transaction_checklists = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$sth_steps = SQL_QUERY("select tcs.*, 
						case tcs.due_event
						  when 'After Checklist Added' then 1
						  when 'After Mutual' then 2
						  when 'After Closing' then 3
						  else 0
						end as num_due_event, tsl.agent_checked, tsl.admin_checked 
						from transaction_checklist_step as tcs
						left join transaction_step_log as tsl on tsl.checklist_step_id=tcs.checklist_step_id 
						where tcs.checklist_id=".SQL_CLEAN($data['checklist_id'])." 
						order by num_due_event,tcs.due_days");

		$steps = array();
		while($data2 = SQL_ASSOC_ARRAY($sth_steps)) {
			$steps[] = $data2;
		}
		$data['steps'] = $steps;
		$transaction_checklists[] = $data;
	}

	// die(print_r($transaction_checklists));

	$sth = SQL_QUERY("select tc.*, u1.first_name, u1.last_name from transaction_comments as tc 
						left join users as u1 on u1.user_id=tc.user_id 
						where tc.transaction_id=".SQL_CLEAN($_GET['id']));

	$transaction_comments = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$transaction_comments[] = $data;
	}

	$sth = SQL_QUERY("select cf.*, cft.name as file_type_name
		from transaction_files as cf 
		left join file_types as cft on cft.file_type_id = cf.file_type_id
		where cf.transaction_id=".SQL_CLEAN($_REQUEST['id'])." and cf.is_deleted=0 
		order by cf.file_name ASC");
	$transaction_files = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$transaction_files[] = $data;
	}

	$sth = SQL_QUERY("select cf.*, cft.name as file_type_name
		from transaction_files as cf 
		left join file_types as cft on cft.file_type_id = cf.file_type_id
		where cf.is_deleted=1 and cf.transaction_id=".SQL_CLEAN($_REQUEST['id'])." 
		order by cf.file_name ASC");
	$deleted_transaction_files = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$deleted_transaction_files[] = $data;
	}

	$sth = SQL_QUERY("select cft.* 
		from file_types as cft 
		where cft.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
		and cft.is_deleted!=1 
		order by cft.name ASC");
	$file_types = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$file_types[] = $data;
	}

	$sth = SQL_QUERY("select t.*, ts.transaction_status, tt.transaction_type, u.company_id as company_id, CONCAT(u.first_name,' ',u.last_name) as created_by
		from transactions as t 
		left join transaction_status as ts on ts.transaction_status_id =  t.transaction_status_id
		left join transaction_type as tt on tt.transaction_type_id =  t.transaction_type_id
		left join users as u on u.user_id =  t.user_id 
		where t.transaction_id=".SQL_CLEAN($_GET['id'])." 
		order by t.date_created ASC");

	// Add transaction log
	add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." viewed a transaction (".$_GET['id'].")", "transaction", array("importance" => "Info", "action" => "View") );

	$transaction = SQL_ASSOC_ARRAY($sth);
	$transaction['date_created'] = convert_to_local($transaction['date_created']);
	$transaction['date_modified'] = convert_to_local($transaction['date_modified']);
	$transaction['date_ended'] = convert_to_local($transaction['date_ended']);
	$transaction['date_projected_complete'] = convert_to_local($transaction['date_projected_complete']);
	$transaction['date_pending'] = convert_to_local($transaction['date_pending']);
	$transaction['date_complete'] = convert_to_local($transaction['date_complete']);

	// die(var_dump($transaction));

	$smarty->assign("company_id", $_SESSION['user']['company_id']);
	$smarty->assign("company_checklists", $company_checklists);
	$smarty->assign("transaction", $transaction);
	$smarty->assign("transaction_types", $transaction_types);
	$smarty->assign("transaction_status", $transaction_status);
	$smarty->assign("transaction_comments", $transaction_comments);
	$smarty->assign("transaction_checklists", $transaction_checklists);
	$smarty->assign("transaction_files", $transaction_files);
	$smarty->assign("deleted_transaction_files", $deleted_transaction_files);
	$smarty->assign("file_types", $file_types);

	$smarty->assign('footer_js', 'includes/footers/transaction_edit.tpl');

	$smarty->display('transaction_edit.tpl');

}

?>
