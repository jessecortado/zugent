<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

if ($_SESSION['user']['is_superadmin'] == "0" && $_SESSION['user']['company_id'] !== "1") {
    
    // Add new user log
    add_user_log("User tried to access impersonate feature (".$_SESSION['user_id'].")", "impersonate", array("importance" => "Critical", "action"=>"Impersonate")  );

    exit;
}



// if($_SESSION['user']['is_superadmin'] == 0)
// 	exit;

if(isset($_POST['user_id'])){

    $user_id = $_SESSION['user']['user_id'];
    $company_id = $_SESSION['user']['company_id'];

	$sth = SQL_QUERY("select * from users where user_id='".SQL_CLEAN($_POST['user_id'])."' and is_active=1 limit 1");
    $data = SQL_ASSOC_ARRAY($sth);

    $sth = SQL_QUERY("
        SELECT
                *
        FROM companies
        WHERE company_id='".SQL_CLEAN($_POST['company_id'])."' AND is_active=1
        LIMIT 1
    ");
    $company_data = SQL_ASSOC_ARRAY($sth);

    $_SESSION['user'] = $data;
    $_SESSION['company'] = $company_data;

    // set old user_ids to session
    $_SESSION['user']['i_user_id'] = $user_id;
    $_SESSION['user']['i_company_id'] = $company_id;
	$_SESSION['user_id'] = $data['user_id'];

	// Add impersonate log
    add_user_log("(".$_SESSION['user']['i_user_id'].") Impersonated user (".$_POST['user_id'].")", "impersonate", array("importance" => "Critical", "action"=>"Impersonate") );
    
    echo json_encode(true);
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0u7");
	}
}

?>      