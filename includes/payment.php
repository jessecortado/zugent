<?php 

$monthly_fee = 149;

$date_last_charge = (isset($_SESSION['company']['date_last_charge'])) ? $_SESSION['company']['date_last_charge'] : date("Y-m-d H:i:s", strtotime("-1 month", strtotime($_SESSION['company']['date_created'])));
$per_user = (isset($_SESSION['company']['cost_per_user'])) ? ($_SESSION['company']['cost_per_user'] / 100) : 0;

$due_date = date("Y-m-d H:i:s", strtotime("+1 month", strtotime($date_last_charge)));
$next_due_date = date("Y-m-d H:i:s", strtotime("+2 month", strtotime($date_last_charge)));
$in_date_last_charge = date("Y-m-d H:i:s", strtotime("-1 day", strtotime($date_last_charge)));
$in_due_date = date("Y-m-d H:i:s", strtotime("+1 month 1 day", strtotime($date_last_charge)));

$nut = SQL_QUERY("select * from users ".
	"where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and ".
	"((is_active = 1) or (is_active = 0 and (date_deactivated between '".SQL_CLEAN($in_date_last_charge)."' and '".SQL_CLEAN($in_due_date)."'))) ".
	"order by user_id asc");

$company_new_users = array();

$data_ctr = 0;
$new_users_total = 0;
while ($data = SQL_ASSOC_ARRAY($nut)) {
	$data_ctr++;
	$company_new_users[] = $data;
	if ($data_ctr > 3) {
		$new_users_total++;
	}
}

function get_company_charge_history() {
	$cch = SQL_QUERY("select * from company_charge_history where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' order by date_charge desc limit 6");

	$company_charge_history = array();

	while ($data = SQL_ASSOC_ARRAY($cch)) {
		$company_charge_history[] = $data;
	}
	
	return $company_charge_history;
}

function calculate_total_amount($monthly_fee, $per_user, $new_users_total) {
	$total_amount = ($monthly_fee + ($per_user * $new_users_total)) * 100;
	return $total_amount;
}

function check_expired_accounts() {
	$cep = SQL_QUERY("select * from companies where date_last_charge <= DATE_SUB(NOW(), INTERVAL 1 MONTH)");

	$expired_accounts = array();

	while ($data = SQL_ASSOC_ARRAY($cep)) {
		$expired_accounts[] = $data;
	}

    if(!empty($expired_accounts)) {
        foreach($expired_accounts as $account)
        {
            // if date_last_charge >= one month set is_billing_current to 0
			SQL_QUERY("update companies set is_billing_current = 0 where company_id='".SQL_CLEAN($account['company_id'])."' limit 1");
        }
    }
}

?>