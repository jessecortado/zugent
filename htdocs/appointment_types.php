<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(true);

$sth = SQL_QUERY("select * from appointment_types where company_id=".SQL_CLEAN($_SESSION['user']['company_id']));
$appointment_active_types = array();
$appointment_inactive_types = array();
while ($data = SQL_ASSOC_ARRAY($sth)) {
	if ($data['is_active'] == 1) {
		$appointment_active_types[] = $data;
	}
	else {
		$appointment_inactive_types[] = $data;
	}
}

$appointment_icons = array(
    array(
        "id" => 'fa-user',
        "text" => 'user'
    ),
    array(
        "id" => 'fa-clock-o',
        "text" => 'clock'
    ),
    array(
        "id" => 'fa-envelope',
        "text" => 'envelope'
    ),
    array(
        "id" => 'fa-phone',
        "text" => 'phone'
    ),
    array(
        "id" => 'fa-coffee',
        "text" => 'coffee'
    ),
    array(
        "id" => 'fa-home',
        "text" => 'home'
    ),
    array(
        "id" => 'fa-star',
        "text" => 'star'
    ),
    array(
        "id" => 'fa-heart',
        "text" => 'heart'
    ),
    array(
        "id" => 'fa-film',
        "text" => 'film'
    ),
    array(
        "id" => 'fa-file',
        "text" => 'file'
    ),
    array(
        "id" => 'fa-lock',
        "text" => 'lock'
    ),
    array(
        "id" => 'fa-book',
        "text" => 'book'
    ),
    array(
        "id" => 'fa-calendar',
        "text" => 'calendar'
    )
);


$smarty->assign('appointment_active_types', $appointment_active_types);
$smarty->assign('appointment_inactive_types', $appointment_inactive_types);
$smarty->assign('appointment_icon_addselect', $appointment_icons);
$smarty->assign('appointment_icons', json_encode($appointment_icons));
$smarty->assign("footer_js", "includes/footers/appointment_types.tpl");

$smarty->display('appointment_types.tpl');
