<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

auth(true);

if(!isset($_GET['id']) && !isset($_POST['first_name'])) {
	header("location: /dashboard.php");
	exit;
}

if(isset($_GET['source'])){
	if($_GET['source'] == "my_profile") {
		$sth = SQL_QUERY("update users set
			url_profile_photo='".SQL_CLEAN($_POST['url_profile_photo'])."',
			is_profile_photo=0 
			where user_id='".$_POST['user_id']."'");

		$sth = SQL_QUERY("select * from users where user_id=".$_SESSION['user_id']);
		$user_data = SQL_ASSOC_ARRAY($sth);
		$_SESSION['user'] = $user_data;

		header("location: /user_view.php?id=".$_POST['user_id']);
	} 
}



$user_id = SQL_CLEAN($_GET['id']);

$sth = SQL_QUERY("select u.*
	from users as u 
	where u.user_id='".$user_id."'
	limit 1");

$user = SQL_ASSOC_ARRAY($sth);

$sth = SQL_QUERY("select o.* from offices as o where o.is_active=1 and o.office_id not in (select uo.office_id from user_rel_offices as uo where uo.user_id=".SQL_CLEAN($_GET['id']).") and o.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." order by o.name");
$active_offices = array();
$ctr = 1;
while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['count'] = $ctr;
	$active_offices[] = $data;
	$ctr++;
}

$sth = SQL_QUERY("select uo.user_rel_office_id, o.* from user_rel_offices as uo 
					left join offices as o on o.office_id=uo.office_id 
					where is_active=1 and uo.user_id=".SQL_CLEAN($_GET['id']).
				" order by o.name");
$user_offices = array();
// $ctr = 1;
while ($data = SQL_ASSOC_ARRAY($sth)) {
	// $data['count'] = $ctr;
	$user_offices[] = $data;
	$ctr++;
}


if($_SESSION['user']['is_profile_photo'] == 1) 
	$smarty->assign("profile_url", 'https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'.$user_id.'/original.jpg?v='.time());
else
	$smarty->assign("profile_url", $_SESSION['user']['url_profile_photo']);

$smarty->assign('timezones', get_timezones());
$smarty->assign('footer_js', 'includes/footers/editable_footer.tpl');
$smarty->assign('offices', $active_offices);
$smarty->assign('user_offices', $user_offices);
$smarty->assign('user_details', $user);
$smarty->assign('admin', $_SESSION['user']);
// $smarty->assign('footer_js', 'includes/footers/profile.tpl');
$smarty->assign('footer_js', 'includes/footers/user_view_footer.tpl');
$smarty->display('user_view.tpl');



?>
