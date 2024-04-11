<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xbuc7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);


if(isset($_POST['bucket_id'])){

	$sth = SQL_QUERY("select distinct tag_name from contact_bucket_tags 
		where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
		bucket_id = '".SQL_CLEAN($_POST['bucket_id'])."' order by bucket_tag_id asc
		");

	$tags = array();

	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$tags[] = $data['tag_name'];
	}

	echo json_encode(array('msg'=>true, 'tags'=>$tags));
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xbuc7");
	}
}

?>