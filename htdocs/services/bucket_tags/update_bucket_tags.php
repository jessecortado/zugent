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


function checkTag($bucket_id, $tag_name) {

	$sth = SQL_QUERY("select * from contact_bucket_tags 
		where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
		bucket_id = '".SQL_CLEAN($bucket_id)."' and 
		upper(tag_name) = upper('".SQL_CLEAN($tag_name)."') limit 1");

	if (SQL_NUM_ROWS($sth) > 0) {
		return true;
	}
	else {
		return false;
	}
}


if(isset($_POST['bucket_id'])){

	// Check for new TagsTags
	if(!empty($_POST['tags'])) {
		$tags = $_POST['tags'];
		foreach ($tags as $value) {
			if (!checkTag($_POST['bucket_id'], $value)) {
				$add_process = SQL_QUERY("insert into contact_bucket_tags (bucket_id,tag_name,user_id,company_id,date_added) values (
					'".SQL_CLEAN($_POST['bucket_id'])."',
					'".SQL_CLEAN($value)."',
					'".SQL_CLEAN($_SESSION['user']['user_id'])."',
					'".SQL_CLEAN($_SESSION['user']['company_id'])."',
					NOW()
				)");

				$tag_id = SQL_INSERT_ID();

				// Add bucket tag log
				add_user_log("Added a bucket tag (".$tag_id.") to bucket (".$_POST['bucket_id'].")", "bucket", array("importance" => "Info", "action" => "Add") );

			}
		}
	}

	// Check removed Tags
	if(!empty($_POST['removed_tags'])) {
		$removed_tags = $_POST['removed_tags'];
		foreach ($removed_tags as $value) {
			if (checkTag($_POST['bucket_id'], $value)) {
				$delete_process = SQL_QUERY("delete from contact_bucket_tags where bucket_id='".SQL_CLEAN($_POST["bucket_id"])."' and upper(tag_name) = upper('".SQL_CLEAN($value)."')");
				
				// Add bucket tag log
				add_user_log("Deleted a bucket tag (".$$value.") to bucket (".$_POST['bucket_id'].")", "bucket", array("importance" => "Info", "action" => "Add") );

			}
		}
	}

	echo json_encode(true);
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