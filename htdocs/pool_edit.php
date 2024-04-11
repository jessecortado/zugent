<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

// Force HTTPS Access
if (!is_https()) {
    header("location: https://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}");
}

check_company_page_access('pools');

auth();


// Workaround for strange bug where a notice appears for each time
// the pool table or pool related tables are used
error_reporting(E_ERROR | E_WARNING | E_PARSE);

// if(isset($_POST['name'])){

// 	$date = date("Y-m-d H:i:s");

// 	$sth = SQL_QUERY("
// 		insert into 
// 			pools set 
// 				name='".SQL_CLEAN($_POST['pool_name'])."'  
// 				, description='".SQL_CLEAN($_POST['description'])."'
// 				, share_level='".SQL_CLEAN($_POST['share_level'])."'
// 				, date_created='".SQL_CLEAN($date)."'
// 				, user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."'
// 				, is_active=0
// 			");

			// $id = SQL_INSERT_ID();

			// $name = $_SESSION['user']['first_name'] . " " . $_SESSION['user']['last_name'];

			// echo json_encode(array('result'=>$sth, 'id'=>$id, 'date_created'=>$date, 'uploaded_by'=>$name));
			// header("location: /contact_pool.php");


// }

// $sth = SQL_QUERY("select p.*, u.first_name, u.last_name from pools as p  
// 	left join users as u on p.user_id=u.user_id 
// 	where u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
// 	order by p.date_updated DESC");		

// $contact_pool = array();

// while ($data = SQL_ASSOC_ARRAY($sth)) {
// 	$contact_pool[] = $data;
// }

// $smarty->assign('contact_pool', $contact_pool);


/* PREVIOUS QUERY */
// $sth = SQL_QUERY("select p.*, u.first_name, u.last_name from pools as p  
// 	inner join users as u on p.user_id=u.user_id and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
// 	where p.pool_id=".SQL_CLEAN($_GET['id'])." and p.user_id=".SQL_CLEAN($_SESSION['user_id'])." or u.is_admin=1 or u.is_superadmin=1");

$sth = SQL_QUERY("select p.*, u.first_name, u.last_name from pools as p  
	inner join users as u on p.user_id=u.user_id 
	where p.pool_id=".SQL_CLEAN($_GET['id'])." and u.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." and (p.user_id=".SQL_CLEAN($_SESSION['user_id'])." or u.is_admin=1 or u.is_superadmin=1)");

if (SQL_NUM_ROWS($sth) == 0)
	header("location: /dashboard.php?code=1xpl7");
	// exit;

$pool = SQL_ASSOC_ARRAY($sth);

$sth = SQL_QUERY("select pi.*, CONCAT(u.first_name,' ',u.last_name) as imported_by from pool_imports as pi 
	left join users as u on pi.user_id=u.user_id where pi.pool_id=".SQL_CLEAN($_GET['id'])." and pi.imported=1");

$pool_imports = array();

while ($data = SQL_ASSOC_ARRAY($sth)) {
	$data['date_uploaded'] = convert_to_local($data['date_uploaded']);
	$pool_imports[] = $data;
}

$smarty->assign('pool', $pool);
$smarty->assign('id', $_GET['id']);
$smarty->assign('pool_imports', $pool_imports);
$smarty->display('pool_edit.tpl');
	

	
?>