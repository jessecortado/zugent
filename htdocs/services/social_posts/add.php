<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xsp7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, TRUE);

if(isset($_POST['field'])){

    $insert_string = "insert into 
				social_posts set
                date_post='".SQL_CLEAN($_POST['appointment_type'])."'
                , user_id='".SQL_CLEAN($_SESSION['user']['user_id'])."'
                , body='".SQL_CLEAN($_POST['body'])."'
                , date_added='NOW()'";
    
    if (in_array("facebook", $_POST['post_where']))
        $insert_string .= ", is_sent_facebook=1";
    if (in_array("twitter", $_POST['post_where']))
        $insert_string .= ", is_sent_twitter=1";
    if (in_array("linkedin", $_POST['post_where'])) {
        $insert_string .= ", is_sent_linkedin=1";
        $subject .= ",subject='".SQL_CLEAN($_POST['subject'])."'";
    }

	$sth = SQL_QUERY($insert_string);

	$id = SQL_INSERT_ID();	
	
	// Add social post log
	add_user_log("Scheduled a social post (".$id.")", "social_posts", array("importance" => "Info", "action" => "Add") );

	echo json_encode(array('msg'=>true, 'appointment_type_id'=>$appointment_type_id, 'appointment_type'=>$_POST['appointment_type']));
}
else {
	if ($is_ajax) {
		echo json_encode(array('msg'=>false));
	}
	else {
		header("location: /dashboard.php?code=1xat7");
	}
}

?>