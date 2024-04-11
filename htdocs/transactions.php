<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/includes/new_transaction.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('transactions');

auth(false, true);

// temporarily disable
// if($_SESSION['user']['is_admin'] == 0)
// header("location: /dashboard.php");

if(!isset($_GET['id'])) {

	$sth = SQL_QUERY("select distinct u.user_id, u.company_id, u.first_name, u.last_name
		from users as u 
		inner join transactions as t on u.user_id = t.user_id
		left join transaction_status as ts on ts.transaction_status_id =  t.transaction_status_id
		left join transaction_type as tt on tt.transaction_type_id =  t.transaction_type_id
		where u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
		order by t.date_created ASC");

	$transactions = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$transactions[] = $data;
	}

	$smarty->assign("company_id", $_SESSION['user']['company_id']);
	$smarty->assign("transactions", $transactions);
	$smarty->assign("footer_js", "includes/footers/transactions_footer.tpl");

	$smarty->display('transactions.tpl');

}
else {
	$sth = SQL_QUERY("select t.*, ts.transaction_status, tt.transaction_type, u.company_id as company_id, u.first_name, u.last_name
		from transactions as t 
		left join transaction_status as ts on ts.transaction_status_id = t.transaction_status_id
		left join transaction_type as tt on tt.transaction_type_id = t.transaction_type_id
		left join users as u on u.user_id = t.user_id 
		where t.user_id=".SQL_CLEAN($_GET['id'])." 
		order by t.date_created ASC");

	$transactions = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$data['transaction_description'] = strip_tags($data['transaction_description']);
		$data['transaction_description'] = str_replace("\n","<BR/>",$data['transaction_description']);

		if (strlen($data['transaction_description']) > 500) {
			$start = substr($data['transaction_description'], 0, 500);
			$end = substr($data['transaction_description'],500,strlen($data['transaction_description']));
			$data['description_start'] = $start;
			$data['description_end'] = $end;
			$data['date_created'] = convert_to_local($data['date_created']);
		}

		$transactions[] = $data;
	}

	// User Selected
	$usr = SQL_QUERY("select * from users where user_id=".SQL_CLEAN($_GET['id'])." limit 1");

	while ($usr_data = SQL_ASSOC_ARRAY($usr)) {
		$company_id = $usr_data['company_id'];
		$selected_user = $usr_data['first_name']." ".$usr_data['last_name'];
	}

	$smarty->assign("transactions", $transactions);
	$smarty->assign("company_id", $company_id);
	$smarty->assign("selected_user", $selected_user);
	$smarty->assign("footer_js", "includes/footers/transactions_view_footer.tpl");

	$smarty->display('transactions_view.tpl');
}


?>
