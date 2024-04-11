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


if(isset($_POST['user_id'])){

	if($_POST['user_id'] == ''){
		$user_id = $_SESSION['user_id'];
	}
	else {
		$user_id = $_POST['user_id'];
	}

	$sth = SQL_QUERY("select c.contact_id as id, concat(c.first_name,' ',c.last_name) as text from contacts as c 
		left join contacts_rel_users as cru on cru.contact_id=c.contact_id 
		where c.company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
		cru.user_id = '".SQL_CLEAN($user_id)."' order by c.contact_id asc
		");

	$user_contacts = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$user_contacts[] = $data;
	}

	echo json_encode(array('msg'=>true, 'user_contacts'=>$user_contacts));
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