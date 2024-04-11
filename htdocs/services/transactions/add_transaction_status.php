<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xts7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['transaction_status'])){


	$sth = SQL_QUERY("insert into transaction_status set ".
		" transaction_status='".SQL_CLEAN($_POST["transaction_status"]).
		"', company_id=".SQL_CLEAN($_POST["company_id"])
		);

	$transaction_status_id = SQL_INSERT_ID();

	// Add transaction log
	add_user_log($_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']." (".$_SESSION['user_id'].") "." added a transaction_status; id=".$transaction_status_id, "transaction", array("importance" => "Info", "action"=>"Add") );

	echo json_encode(array('msg'=>$sth, 'transaction_status_id'=>$transaction_status_id, 'transaction_status'=>$_POST['transaction_status']));
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