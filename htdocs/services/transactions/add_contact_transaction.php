<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xts7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
	"main_table_name" => 'contacts',
	"main_table_field" => 'contact_id',
	"main_field_value" => $_POST['contact_id'],
	"additional_where" => array(
		"contact_id" => $_POST['contact_id'],
		"company_id" => $_SESSION['user']['company_id']
	)
);

auth_process($data, $is_ajax, TRUE);


	// echo "<pre>";
	// print_r($_POST);
	// echo "</pre>";
	// die('TEST');

if(isset($_POST['transaction_type_id'])){

	$date = gmdate("Y-m-d H:i:s");

	$sth = SQL_QUERY("
			insert into 
				transactions set 
				transaction_description='".SQL_CLEAN($_POST['description']).
				"', transaction_type_id='".SQL_CLEAN($_POST['transaction_type_id']).
				"', transaction_status_id='".SQL_CLEAN($_POST['transaction_status_id']).
				"', date_created='".SQL_CLEAN($date).
				"', user_id='".SQL_CLEAN($_SESSION['user']['user_id']).
				"', company_id='".SQL_CLEAN($_SESSION['user']['company_id']).
				"', contact_id='".SQL_CLEAN($_POST['contact_id'])
				."'");

	$transaction_id = SQL_INSERT_ID();


	if (isset($_POST['transaction_alert_id']) && !empty($_POST['transaction_alert_id'])) {
		// if exists update is_on_mls to 1
		SQL_QUERY("update transactions set 
			is_on_mls = 1, 
			mls_id = '".$_POST['mls_id']."', 
			listing_number = '".$_POST['listing_number']."' 
			where transaction_id = '".$transaction_id."'");
		// if exists update transactio_id
		SQL_QUERY("update transaction_alerts set 
			transaction_id = '".$transaction_id."' 
			where transaction_alert_id = '".$_POST['transaction_alert_id']."'");
	}


    // Add transaction log
	add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." added a new transaction for contact id (".$_POST['contact_id'].")", "transaction", array("importance" => "Info", "action"=>"Add"), $_POST['contact_id'] );

	$sth = SQL_QUERY("select t.*, ts.transaction_status, tt.transaction_type, u.company_id as company_id from transactions as t 
		left join transaction_status as ts on ts.transaction_status_id = t.transaction_status_id 
		left join transaction_type as tt on tt.transaction_type_id = t.transaction_type_id 
		left join users as u on u.user_id = t.user_id 
		where t.contact_id=".SQL_CLEAN($_POST['contact_id'])." 
		and t.transaction_id=".SQL_CLEAN($transaction_id)." 
		order by t.date_created ASC");

	$recently_added_data = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$data['date_created'] = convert_to_local($data['date_created']);
		$recently_added_data[] = $data;
	}

	echo json_encode(array('msg'=>true, 'data'=>$recently_added_data));
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xts7");
	}
}

?>