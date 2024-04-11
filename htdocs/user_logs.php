<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(true);

// log levels: Critical, Info, Error, Trace

$dev_ids = array('1', '2', '3', '4', '146', '144');
$critical_types = array("login", "billing");
$important_types = array("referrals", "transactions", "assignments");
$info_types = array("appointment_types");

$actions = array("View", "Update", "Add");
$importance = array();
$pages = array();

if (!in_array($_SESSION['user_id'],$dev_ids)) 
    exit;

$sth = SQL_QUERY("select ul.*, u.first_name, u.last_name, c.company_name from user_log as ul 
                    left join users u on ul.user_id=u.user_id 
                    left join companies as c on u.company_id=c.company_id 
                    order by ul.date_created DESC");
$log = array();

while($data = SQL_ASSOC_ARRAY($sth)) {
    $params = json_decode($data["params"], true);
    // die(var_dump($params));
    $log[] = $data;
}

$smarty->assign('log', $log);
$smarty->display('user_logs.tpl');
    
?>
