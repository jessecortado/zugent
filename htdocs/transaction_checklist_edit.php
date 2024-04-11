<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('transactions');

auth(true);

// $date = date("Y-m-d H:i:s");

// $sth = SQL_QUERY("update transaction_checklists set 
// 					checklist_name='".SQL_CLEAN($_POST['checklist_name'])."', 
// 					date_modified='".SQL_CLEAN($date)."', 
// 					modified_user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."' where  
// 					checklist_id='".SQL_CLEAN($_GET['id'])."' and company_id='".SQL_CLEAN($_SESSION['user']['company_id']."'
// 				");


// temporarily disable
// if($_SESSION['user']['is_admin'] == 0)
// header("location: /dashboard.php");
$id;

if (isset($_POST['checklist_id']))
	$id = $_POST['checklist_id'];
else if (isset($_GET['checklist_id']))
	$id = $_GET['checklist_id'];

if (isset($_POST['checklist_id'])) {
	$date = date("Y-m-d H:i:s");

	$sth = SQL_QUERY("update transaction_checklists set 
						checklist_name='".SQL_CLEAN($_POST['checklist_name'])."', 
						description='".SQL_CLEAN($_POST['description'])."', 
						transaction_type_id='".SQL_CLEAN($_POST['transaction_type_id'])."', 
						date_modified='".SQL_CLEAN($date)."', 
						modified_user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."' where  
						checklist_id='".SQL_CLEAN($_POST['checklist_id'])."' and company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
					");

	header("location: /transaction_checklist_edit.php?checklist_id=".$id);
}

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
					where tc.checklist_id=".SQL_CLEAN($id)." and tc.company_id=".SQL_CLEAN($_SESSION['user']['company_id']));

if (SQL_NUM_ROWS($sth) == 0)
	header("location: /transaction_checklists.php");

$checklist = SQL_ASSOC_ARRAY($sth);


$sth = SQL_QUERY("select *, 
					case due_event
					  when 'After Checklist Added' then 1
					  when 'After Mutual' then 2
					  when 'After Closing' then 3
					  else 0
					end as num_due_event 
					from transaction_checklist_step 
					where checklist_id=".SQL_CLEAN($id)." 
					order by num_due_event,due_days");

$steps = array();
while($data = SQL_ASSOC_ARRAY($sth)) {
	$steps[] = $data;
}

$smarty->assign("company_id", $_SESSION['user']['company_id']);
$smarty->assign("checklist", $checklist);
$smarty->assign("steps", $steps);
$smarty->assign('transaction_status', $transaction_status);
$smarty->assign('transaction_types', $transaction_types);

$smarty->assign('footer_js', 'includes/footers/transaction_checklist_edit_footer.tpl');
$smarty->display('transaction_checklist_edit.tpl');

?>
