<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x007',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax);

if (isset($_POST['months']) || isset($_POST['weeks']) || isset($_POST['days'])) {
    $defined_date = date("Y-m-d");
    $old_due_date;
    $due_date = date("Y-m-d");
    $duration;
    $time_left;
    $no_existing_timetoaction = true;
    $added_time = "";
    $days = 0;

    // Add inputted values to current date
    if (!empty($_POST['months'])) {
        $added_time = "+".$_POST['months']." months ";
    }
    if (!empty($_POST['weeks'])) {
        $days += $_POST['weeks'] * 7;
    }
    if (!empty($_POST['days'])) {
        $days += $_POST['days'];
    }

    if ($days > 0)
        $added_time .= "+".$days." days";

    // Get te new due date
    $due_date = strtotime($added_time, strtotime($due_date));

    // Get old due date from here instead of from post data to avoid inconsistencies
    $sth = SQL_QUERY("select date_due_timetoaction from contacts where contact_id=".SQL_CLEAN($_POST['contact_id']));
    $temp = SQL_ASSOC_ARRAY($sth);
    
    $sth = SQL_QUERY("update contacts set ".
            "date_defined_timetoaction='".SQL_CLEAN($defined_date).
            "', date_due_timetoaction='".SQL_CLEAN(date("Y-m-d", $due_date)).
            "' where contact_id=".SQL_CLEAN($_POST['contact_id'])
    );

    if ($sth) {
    
        $insert_history = SQL_QUERY("insert into contact_timetoaction_history set ".
                "date_defined_timetoaction='".SQL_CLEAN($defined_date).
                "', date_due_timetoaction='".SQL_CLEAN(date("Y-m-d", $due_date)).
                "', date_added='".SQL_CLEAN(date("Y-m-d H:i:s")).
                "', user_id='".SQL_CLEAN($_SESSION['user_id']).
                "', contact_id=".SQL_CLEAN($_POST['contact_id'])
        );

		$start = strtotime($defined_date);
		$end = strtotime($due_date);
		$current = gmdate(date("Y-m-d"));
        $duration = (($current - $start) / ($end - $start)) * 100;

        $time_left = date_difference($defined_date, date("Y-m-d", $due_date));

        // Check for existing time to action then due other processes involved if there is
        if (!empty($temp['date_due_timetoaction'])) {

            // Add comment set type id to 10
            $comment = "The time to action has been changed from ".date("M jS Y", strtotime($temp['date_due_timetoaction']))." to ".date("M jS Y", $due_date)." ".$time_left." from this comment";

            // Insert comment
            SQL_QUERY("
                insert into contact_comments 
                (
                    user_id
                    , contact_id
                    , date_added
                    , comment
                    , comment_type_id
                ) values (
                    '".SQL_CLEAN($_SESSION['user_id'])."'
                    , '".SQL_CLEAN($_POST['contact_id'])."'
                    , NOW()
                    , '".SQL_CLEAN($comment)."'
                    , 10
                )
            ");
        }
    }
    else 
        echo json_encode($sth);

    // Add contact log (Edit)
	add_user_log("Updated a contact's (".$_POST['contact_file_id'].") time to action", "contacts", array("importance" => "Info", "action" => "Update") );
    echo json_encode(array("msg" => "success (".$sth.")", "time_left" => $time_left));
}
// date_defined_timetoaction
// date_due_timtoaction
