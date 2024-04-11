<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

// Check is session exists
$checkImpersonator = SQL_QUERY("select is_superadmin, company_id from users where user_id='".SQL_CLEAN($_SESSION['user']['i_user_id'])."' and company_id='".SQL_CLEAN($_SESSION['user']['i_company_id'])."' and is_active=1 limit 1");

if (SQL_NUM_ROWS($checkImpersonator) != 0) {

    $impersonator_data = SQL_ASSOC_ARRAY($checkImpersonator);

    if ($impersonator_data['is_superadmin'] !== 1 && $impersonator_data['company_id'] !== "1") {
        // Add new user log
        add_user_log("User tried to access impersonate feature (".$_SESSION['user_id'].")", "login", array("importance" => "Critical", "action"=>"Impersonate")  );
        exit;
    }

}
else {
    // Add new user log
    add_user_log("User tried to access impersonate feature (".$_SESSION['user_id'].")", "login", array("importance" => "Critical", "action"=>"Impersonate")  );
    exit;
}

    $user_id = $_SESSION['user']['user_id'];
    $company_id = $_SESSION['user']['company_id'];

	$sth = SQL_QUERY("select * from users where user_id='".SQL_CLEAN($_SESSION['user']['i_user_id'])."' and is_active=1 limit 1");
    $data = SQL_ASSOC_ARRAY($sth);

    $sth = SQL_QUERY("
        SELECT
                *
        FROM companies
        WHERE company_id='".SQL_CLEAN($_SESSION['user']['i_company_id'])."' AND is_active=1
        LIMIT 1
    ");
    $company_data = SQL_ASSOC_ARRAY($sth);
    
    // Add impersonate log
    add_user_log("(".$_SESSION['user']['i_user_id'].") Finished impersonating user (".$_SESSION['user_id'].")", "login", array("importance" => "Critical", "action"=>"Impersonate") );

    unset($_SESSION['user']);
    unset($_SESSION['company']);
    unset($_SESSION['user_id']);

    $_SESSION['user'] = $data;
    $_SESSION['company'] = $company_data;
    $_SESSION['user_id'] = $data['user_id'];


    echo json_encode($data);

?>      