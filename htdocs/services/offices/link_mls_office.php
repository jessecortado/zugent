<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xof7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['mls_id'])) {

	$sth = SQL_QUERY("insert into office_rel_offices set  
						mls_id='".SQL_CLEAN($_POST['mls_id']).
						"', office_id='".SQL_CLEAN($_POST['office_id']).
                        "', mls_office_id='".SQL_CLEAN($_POST['mls_office_id']).
                        "'"
					);

	$id = SQL_INSERT_ID();

	// Add office log
	add_user_log("Linked an office (".$_POST['mls_office_id'].") from MLS (".$_POST['mls_id'].") to the office (".$_POST['office_id'].")", "offices", array("importance" => "Info", "action" => "Add") );

    echo json_encode(array("office_id"=> $_POST['office_id'], "mls_office_id" => $_POST['mls_office_id'], "mls_id" => $_POST['mls_id']));

}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xof7");
	}
}

?>