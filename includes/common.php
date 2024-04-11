<?php
require_once($_SERVER['SITE_DIR'].'/includes/PHPMailer/PHPMailerAutoload.php');
require_once($_SERVER['SITE_DIR']."/includes/db.php");
require_once($_SERVER['SITE_DIR']."/includes/smarty/libs/Smarty.class.php");
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
$site_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV
// DO NOT HARD CODE THIS TO READ SITE_CONFIG.DEV



global $smarty, $site_config;

$smarty = new Smarty();
$smarty->compile_check = true;

$smarty->template_dir = $_SERVER['SITE_DIR']."/templates/";
$smarty->compile_dir = $_SERVER['SITE_DIR']."/templates_c/";
$smarty->plugins_dir = array($_SERVER['SITE_DIR']."/includes/smarty/libs/plugins",$_SERVER['SITE_DIR']."/includes/smarty_plugins");

$smarty->assign('recaptcha_key', $site_config['reCAPTCHA']['site_key']);
$smarty->assign( 'site_config', $site_config);

if (!SQL_CONNECT($site_config['MySQL']['Hostname'], $site_config['MySQL']['Username'], $site_config['MySQL']['Password'])) {
	$smarty->display('maintenance.tpl');
	exit;
}

session_start();

// http://sliptree.github.io/bootstrap-tokenfield/

function contact_viewable($contact_id) {
	if ($_SESSION['user']['is_admin'] || $_SESSION['user']['is_superadmin']) {

		$sth = SQL_QUERY("
			select
				*
			from contacts_rel_users as ru
			left join users as u on u.user_id=ru.user_id
			where u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'
			and ru.is_deleted != 1
			and ru.contact_id='".SQL_CLEAN($contact_id)."'
			limit 1
		");
		if (SQL_NUM_ROWS($sth) == 0) {
			header("location: /dashboard.php?e=a0189");
			exit;
		}

	} else {

		$sth = SQL_QUERY("
			select
				*
			from contacts_rel_users
			where user_id='".SQL_CLEAN($_SESSION['user_id'])."'
			and is_deleted != 1
			and contact_id='".SQL_CLEAN($contact_id)."'
			limit 1
		");
		if (SQL_NUM_ROWS($sth) == 0) {
			header("location: /dashboard.php?e=a0189");
			exit;
		}

	}

	$assign_data = SQL_ASSOC_ARRAY($sth);
	return $assign_data;
}

function is_https() {
    if (isset($_SERVER['HTTPS']) and $_SERVER['HTTPS'] == 1) {
        return TRUE;
    } elseif (isset($_SERVER['HTTPS']) and $_SERVER['HTTPS'] == 'on') {
        return TRUE;
    } else {
        return FALSE;
    }
}

function isMobileDevice() {
    $aMobileUA = array(
        '/iphone/i'             => 'iPhone',
        '/ipod/i'               => 'iPod',
        '/ipad/i'               => 'iPad',
        '/android/i'            => 'Android',
        '/blackberry/i'         => 'BlackBerry',
        '/webos/i'              => 'Mobile'
    );

    $data = array(
    	'isDesktop' => true,
    	'isMobile' => false,
    	'deviceName' => $_SERVER['HTTP_USER_AGENT']
    );

    //Return true if Mobile User Agent is detected
    foreach($aMobileUA as $sMobileKey => $sMobileOS){
        if(preg_match($sMobileKey, $_SERVER['HTTP_USER_AGENT'])){
            $data['isDesktop'] = false;
            $data['isMobile'] = true;
            $data['deviceName'] = $sMobileOS;
            break;
        }
    }

    //Otherwise return false..  
    return $data;
}

function encryptCookie($value) {
	$key = 'etH`3?*}T&3tY?hX,U?3`f5.Hg@aPc';
	$newvalue = base64_encode( mcrypt_encrypt( MCRYPT_RIJNDAEL_256, md5( $key ), $value, MCRYPT_MODE_CBC, md5( md5( $key ) ) ) );
	return $newvalue;
}

function decryptCookie($value) {
	$key = 'etH`3?*}T&3tY?hX,U?3`f5.Hg@aPc';
	$newvalue = rtrim( mcrypt_decrypt( MCRYPT_RIJNDAEL_256, md5( $key ), base64_decode( $value ), MCRYPT_MODE_CBC, md5( md5( $key ) ) ), "\0");
	return $newvalue;
}

function user_logged_in($user_id, $company_id) {
	SQL_QUERY("update users set date_last_login=NOW() where user_id=".SQL_CLEAN($user_id)." and company_id=".SQL_CLEAN($company_id)." and is_active=1");
}

function user_last_seen($user_id, $company_id) {
	SQL_QUERY("update users set date_last_seen=NOW() where user_id=".SQL_CLEAN($user_id)." and company_id=".SQL_CLEAN($company_id)." and is_active=1");
}

function check_company_page_access($access_page) {
	$company = SQL_QUERY("select has_".$access_page." from companies where company_id=".SQL_CLEAN($_SESSION['company']['company_id'])." limit 1");

	$has_access = SQL_ASSOC_ARRAY($company);

	if ($has_access['has_'.$access_page] != 1) {
		header("location: /dashboard.php?code=1x007");
	}
}

function check_user_access($user_id, $company_id) {

	$user_exists = SQL_QUERY("select * from users where user_id=".SQL_CLEAN($user_id)." and is_active=1 limit 1");
	$user_company_exists = SQL_QUERY("select * from users where user_id=".SQL_CLEAN($user_id)." and company_id=".SQL_CLEAN($company_id)." and is_active=1 limit 1");

	// checks user if exists on database
	$exists = (SQL_NUM_ROWS($user_exists) != 0) ? (SQL_NUM_ROWS($user_company_exists) != 0) ? TRUE : FALSE : FALSE;

	return $exists;
}

function check_data_access($data, $admin = FALSE, $superadmin = FALSE) {
	//check if $data has an empty or null value
	$data_check = TRUE;
	foreach ($data as $key => $value) {
		if(is_null($value)) {
		    return $data_check = FALSE;
		    break;
		}
	}

	if ($data_check) {
		// check data on database if it matches
		if (isset($data['table_join_name'])) {
			$query_string = 'select t1.* from '.SQL_CLEAN($data['main_table_name']).' as t1 ';
			$query_string .= 'left join '.SQL_CLEAN($data['table_join_name']).' as t2 on t2.'.SQL_CLEAN($data['table_join_field']).' = t1.'.SQL_CLEAN($data['table_join_field']).' ';
			$query_string .= 'where t1.'.SQL_CLEAN($data['main_table_field']).'='.SQL_CLEAN($data['main_field_value']).'';
			if (isset($data['additional_where'])) {
				foreach ($data['additional_where'] as $key => $value) {
					if ($superadmin || $admin) {
						if (!strpos($key, 'user_id')) { $query_string .= ' and '.SQL_CLEAN($key).'='.SQL_CLEAN($value).''; }
					}
					else { $query_string .= ' and '.SQL_CLEAN($key).'='.SQL_CLEAN($value).''; }
				}
			}
			$query_string .= ' limit 1';

			$query = SQL_QUERY($query_string);
			$access = (SQL_NUM_ROWS($query) == 0) ? FALSE : TRUE;
		}
		else {
			$query_string = 'select * from '.SQL_CLEAN($data['main_table_name']).' where '.SQL_CLEAN($data['main_table_field']).'='.SQL_CLEAN($data['main_field_value']).'';
			if (isset($data['additional_where'])) {
				foreach ($data['additional_where'] as $key => $value) {
					if ($superadmin || $admin) {
						if (!strpos($key, 'user_id')) { $query_string .= ' and '.SQL_CLEAN($key).'='.SQL_CLEAN($value).''; }
					}
					else { $query_string .= ' and '.SQL_CLEAN($key).'='.SQL_CLEAN($value).''; }
				}
			}
			$query_string .= ' limit 1';

			$query = SQL_QUERY($query_string);
			$access = (SQL_NUM_ROWS($query) == 0) ? FALSE : TRUE;
		}
	}
	else {
		$access = FALSE;
	}

	return $access;
}

// Authentication for Processes
function auth_process($data, $is_ajax = FALSE, $admin = FALSE, $superadmin = FALSE) {

	$user_exists = check_user_access($data['user_id'], $data['user_company_id']);

	if (isset($data['main_table_name'])){
		$has_access = check_data_access($data, $_SESSION['user']['is_admin'], $_SESSION['user']['is_superadmin']);
	}
	else { $has_access = TRUE; }

	// check user and company if exists
	if ($user_exists) {
		// check user if has_access on data
		if ($has_access) {
			// check user if admin or superadmin
			if ($superadmin && !$_SESSION['user']['is_superadmin']) {
				// is_ajax = check if request is ajax or a direct access from url
				if($is_ajax) { echo json_encode(false); }
				else { header("location: /dashboard.php?code=".$data['code']); }
				exit;
			}
			if ($admin && !$_SESSION['user']['is_admin']) {
				// is_ajax = check if request is ajax or a direct access from url
				if($is_ajax) { echo json_encode(false); }
				else { header("location: /dashboard.php?code=".$data['code']); }
				exit;
			}
		}
		else {
			if($is_ajax) { echo json_encode(false); }
			else { header("location: /dashboard.php?code=".$data['code']); }
			exit;
		}
	}
	else {
		if($is_ajax) { echo json_encode(false); }
		else { header("location: /dashboard.php?code=".$data['code']); }
		exit;
	}
}

function auth($admin = FALSE, $is_beta = FALSE) {

	if (!isset($_SESSION['user_id'])) {
		$url = "/login.php?code=9x22";
		if ($_SERVER['PHP_SELF'] !== "/login.php")
			$url .= "&from=".$_SERVER['REQUEST_URI'];
		header("location: ".$url);
		exit;
	} else {

		//set date user last seen
		user_last_seen($_SESSION['user_id'], $_SESSION['user']['company_id']);

		// if admin_only set to true and user is not an admin = redirect
		if ($admin && (!$_SESSION['user']['is_admin'] && !$_SESSION['user']['is_superadmin'])) {
			header("location: /dashboard.php?code=1x007");
			exit;
		}
		if ($is_beta && !$_SESSION['user']['is_beta']) {
			header("location: /dashboard.php?code=1x08");
			exit;
		}
	}
}

function send_message($from, $to, $subject, $body) {
	global $smarty;
	$mail_array = array('subject' => $subject, 'body' => $body);

	$smarty->assign('mail_to', $to);
	$smarty->assign('mail', $mail_array);
	$smarty->assign('body', $body);
	// $message_body = $smarty->fetch("email_templates/standard.tpl");
	$message_body = $smarty->fetch("email_templates/standard_new.tpl");

	$mail = new PHPMailer;
	$mail->isSMTP();
	$mail->Host = 'email-smtp.us-west-2.amazonaws.com';

	$mail->SMTPAuth = true;
	$mail->Username = 'AKIASGPKA5DXDSAQC5EI';
	$mail->Password = 'BM18NYfut/BkhvbcY5fafCyewUZLzRW9Bhx/E1DNq0/a';

	$mail->SMTPSecure = 'tls';
	$mail->Port = 587;
	$mail->IsHTML(true);

	if(isset($company)) {
		if ($company['logo_file'] == '') {
			$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/ZugEntLogo.png','logo_cid');
		} else {
			$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/'.$company['logo_file'],'logo_cid');
		}
	}

	$mail->Subject = $subject;
	$mail->Body    = $message_body;
	$mail->AltBody = "";

	// $mail->AddReplyTo($from[0], $from[1]);
	$mail->SetFrom("support@ruopen.com", "RUOPEN Mail");

	$mail->addAddress($to[0], $to[1], 34);
	// $mail->Priority = 1;

	$ret = $mail->Send();
	//print_r($mail);
	//print_r($ret);
	return $ret;
}

function email_error_alert($subject, $process, $error_trace) {
	global $smarty;

	$to = array("support@ruopen.com", "");

	$mail_msg = "<b>".$_SESSION['user']['first_name']." ".$_SESSION['user']['last_name']."</b> recieved an error ".$process.".<br/><br/>\n";
    $mail_msg .= "<b>User Contact Details</b><br/>\n";
    $mail_msg .= "<b>Company:</b> ".$_SESSION['company']['company_name']."<br/>\n";
    $mail_msg .= "<b>Mobile:</b> ".$_SESSION['user']['phone_mobile']."<br/>\n";
    $mail_msg .= "<b>Email:</b> ".$_SESSION['user']['email']."<br/><br/>\n";

    $body_template = '<tr>
		                <td class="last">
		                    <h4>'.$subject.'</h4>
		                </td>
		            </tr>
		            <tr>
		                <td class="panel">
		                    '.$mail_msg.'
		                </td>
		            </tr>
		            <tr>
		                <td class="panel">
		                	<b>Error Message</b><br/>
		                    <p>'.$error_trace.'</p>
		                </td>
		            </tr>
		            <tr>
		                <td class="panel">
		                	<b>Other Details</b><br/>
		                    <p><b>SERVER REQUEST URI</b>: '.$_SERVER['REQUEST_URI'].'</p>
		                </td>
		            </tr>';

	$mail_array = array('subject' => $subject, 'body' => $body_template);

	$smarty->assign('mail_to', $to);
	$smarty->assign('mail', $mail_array);
	$smarty->assign('body', $body_template);
	$message_body = $smarty->fetch("email_templates/standard_new.tpl");

	$mail = new PHPMailer;
	$mail->isSMTP();
	$mail->Host = 'email-smtp.us-west-2.amazonaws.com';

	$mail->SMTPAuth = true;
	$mail->Username = 'AKIASGPKA5DXDSAQC5EI';
	$mail->Password = 'BM18NYfut/BkhvbcY5fafCyewUZLzRW9Bhx/E1DNq0/a';

	$mail->SMTPSecure = 'tls';
	$mail->Port = 587;
	$mail->IsHTML(true);

	if(isset($company)) {
		if ($company['logo_file'] == '') {
			$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/ZugEntLogo.png','logo_cid');
		} else {
			$mail->AddEmbeddedImage($_SERVER['SITE_DIR'].'/htdocs/assets/logos/'.$company['logo_file'],'logo_cid');
		}
	}

	$mail->Subject = $subject;
	$mail->Body    = $message_body;
	$mail->AltBody = "";

	// $mail->AddReplyTo($from[0], $from[1]);
	$mail->SetFrom("support@ruopen.com", "RUOPEN Mail");

	$mail->addAddress($to[0], $to[1], 34);
	// $mail->Priority = 1;

	$ret = $mail->Send();
	//print_r($ret);
	return $ret;
}


function geocode($address) {
	// https://developers.google.com/maps/documentation/geocoding/start
	$api_key = "AIzaSyDRBXks6G9tzZrO6nfBWRWMzTUlBgZ9EwY";
	$url = "https://maps.googleapis.com/maps/api/geocode/json?address=".urlencode($address)."&sensor=false&key=".$api_key;
	$data = file_get_contents($url);
    $json = json_decode($data);
    if (isset($json->results[0]->formatted_address)) return array($json->results[0]->geometry->location->lat,  $json->results[0]->geometry->location->lng);
    return false;
}

function generate_random_string($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

function get_contacts_count($admin = FALSE) {
	$count = array();

	$sql = "
		select
			c.contact_id
			, c.bucket_id
			, IF(c.bucket_id = 0,1,0) as is_undefined
			, IF((cu.date_viewed = 0 or cu.date_viewed is null or cu.date_viewed='0000-00-00 00:00:00') and c.bucket_id = 0,1,0) as is_new
			, cu.date_viewed
		from contacts_rel_users as cu
		left join contacts as c on c.contact_id=cu.contact_id
		left join users as u on u.user_id=cu.user_id
	";
	if ($admin) {
		// $sql .= "where u.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and cu.is_deleted != 1";
		$sql .= "where c.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."'";
	} else {
		$sql .= "where cu.user_id='".SQL_CLEAN($_SESSION['user_id'])."' and cu.is_deleted != 1";
	}
	$sth = SQL_QUERY($sql);

	$undefined = 0;
	$new = 0;
	$bucket_counter = array();
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		$temp = "bucket-".$data['bucket_id'];
		$bucket_counter[$temp]++;
		if ($data['is_new']) $new++;
		if ($data['is_undefined']) $undefined++;
	}

	$count["undefined"]["Undefined"]["count"] = $undefined;
	$count["undefined"]["Undefined"]["id"] = 1;
	$count["undefined"]["Undefined"]["name"] = "Undefined";

	$count["new"]["New"]["count"] = $new;
	$count["new"]["New"]["id"] = 1;
	$count["new"]["New"]["name"] = "New";

	$count["all_contacts_count"] = SQL_NUM_ROWS($sth);

	$sth_buckets = SQL_QUERY("
		select distinct
			cb.*
		from contact_buckets as cb
		inner join contacts as c on c.bucket_id=cb.bucket_id
		where cb.company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' and cb.is_dashboard=1
	");

	while ($bucket = SQL_ASSOC_ARRAY($sth_buckets)) {
		$key = $bucket['bucket_name'];
		$temp = "bucket-".$bucket['bucket_id'];
		$count["bucket"][$key]["count"] = $bucket_counter[$temp];
		$count["bucket"][$key]["id"] = $bucket["bucket_id"];
		$count["bucket"][$key]["name"] = $bucket["bucket_name"];
	}

	return $count;

}

function ordinal_suffix($number) {
	$ends = array('th','st','nd','rd','th','th','th','th','th','th');
	if ((($number % 100) >= 11) && (($number%100) <= 13)) {
		return $number. 'th';
	} else {
		return $number. $ends[$number % 10];
	}
}

function random_str($length, $keyspace = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
{
    $str = '';
    $max = mb_strlen($keyspace, '8bit') - 1;
    for ($i = 0; $i < $length; ++$i) {
        $str .= $keyspace[mt_rand(0, $max)];
    }
    return $str;
}

function get_timezones()
{
	// $regions = array('America');
	$tzs = timezone_identifiers_list(2);
	$timezones = array();
	// sort($tzs);
	foreach ($tzs as $tz) {
	    $z = explode('/', $tz, 2);
	    $timezones[] = array(
	    					"name" => $z[1],
	    					"value" => $tz
	    				);
	}

	return $timezones;
}

function set_timezone()
{
	// if (!empty($_SESSION['company']['timezone'])) {
	// 	date_default_timezone_set($_SESSION['company']['timezone']);
	// }
	// else {
	// 	if (!empty($_SESSION['user']['timezone'])) {
	// 		date_default_timezone_set($_SESSION['user']['timezone']);
	// 	}
	// }

	if (!empty($_SESSION['user']['timezone'])) {
		date_default_timezone_set($_SESSION['user']['timezone']);
	}
	else {
		if (!empty($_SESSION['company']['timezone'])) {
			date_default_timezone_set($_SESSION['company']['timezone']);
		}
		else {
			date_default_timezone_set("America/Los_Angeles"); // same as UTC-8:00
		}
	}
}

function convert_to_local($date)
{
	set_timezone();
	$time = strtotime($date);

	// $time = strtotime($date.' UTC');
	return date("Y-m-d H:i:s", $time);
}

function get_notifications($limit = 10, $offset = null) {

	$str = "select *, timestampdiff(hour,date_created,now()) as hours_passed from notifications
						where user_id=". SQL_CLEAN($_SESSION['user_id'])."
						order by seen ASC, date_created DESC";

	if ($limit > 0) {
		$str .= " limit ".$limit;
		if ($offset > 0)
			$str .= " offset ".$offset;
	}

	$sth = SQL_QUERY($str);

	$notifications = array();
	$new_count = 0;
	while ($data = SQL_ASSOC_ARRAY($sth)) {
		if ($data['hours_passed'] < 1) {
			$data['time_elapsed'] = "less than an hour ago";
		}
		else if ($data['hours_passed'] >= 1 && $data['hours_passed'] <= 2) {
			$data['time_elapsed'] = "1 hour ago";
		}
		else if ($data['hours_passed'] >= 24) {
			$days = (int) ($data['hours_passed']/24);
			$data['time_elapsed'] = $days . " day/s ago";
		}
		else if ($data['hours_passed'] >= 168) {
			$data['time_elapsed'] = date("M j, Y", convert_to_local($data['date_created']));
		}
		else {
			$data['time_elapsed'] = $data['hours_passed'] . " hours ago";
		}

		if ($data['seen'] == 0)
			$new_count++;

		$data['date_created'] = convert_to_local($data['date_created']);
		$notifications[] = $data;

	}

	return array("data" => $notifications, "new" => $new_count);
}

function add_notification($user_id = null, $title = "", $notification = "", $url_action = "javascript:;") {

	$str = "insert into notifications (user_id, title, notification, url_action, date_created)
				values ('".SQL_CLEAN($user_id)."','".SQL_CLEAN($title)."','".SQL_CLEAN($notification)."','".SQL_CLEAN($url_action)."', NOW())
			";

	SQL_QUERY($str);
}

function check_number($number) {

	$number = preg_replace("/[^0-9]/", "", $number);

	if ($number !== "")
		if (strlen($number) == 10) {
			$number = "+1".$number;
		} else {
			$number = "+".$number;
		}

	return $number;

}

function add_user_log($log_message = null, $page = "none", $options = array(), $contact_id = null) {

    $url = (isset($_SERVER['HTTPS']) ? "https" : "http") . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
    $params = array("url" => $url);

    if (isset($_POST)) {
        if (isset($_POST["password"]))
            unset($_POST["password"]);
            $params["data"] = $_POST;
            $params["method"] = "POST";
        }
        else if (isset($_GET)) {
            $params["data"] = $_GET;
            $params["method"] = "GET";
        }

    // die ("".json_encode($params));ˀ
    // check for each value in data. None should be over 80 characters add [truncated] at the end

        $result = SQL_QUERY("insert into user_log (user_id, message, page, params, contact_id)
            values (".SQL_CLEAN($_SESSION['user_id']).",'".SQL_CLEAN($log_message)."','".SQL_CLEAN($page)."','".SQL_CLEAN(json_encode($params))."','".SQL_CLEAN($contact_id)."')"."
            ");

	}

	function date_difference($date_1, $date_2, $difference_format = '%m-%d', $return_format = "string")
	{
		// convert to datetimes
		$datetime_1 = new DateTime($date_1);
		$datetime_2 = new DateTime($date_2);

		// get the differnce or interval bet. 2 dates
		$interval = $datetime_1->diff($datetime_2);

		if ($return_format == "string") {
			$array = explode("-", $interval->format($difference_format));
			$return_string = "";

			// Get Months
			if ($array[0] !== "0") {
				if ($array[0] == "1")
					$return_string .= $array[0]." month ";
				else
					$return_string .= $array[0]." months ";
			}
			if ($array[1] !== "0") {
				// Get Weeks then days
				if ($array[1] >= "7") {
					if (round($array[1]/7) == 1)
						$return_string .= round($array[1]/7)." week ";
					else
						$return_string .= round($array[1]/7)." weeks ";
				}
				if (($array[1]%7) == "1")
					$return_string .= ($array[1]%7)." day";
				else {
					$return_string .= ($array[1]%7)." days";
				}
			}

			return $return_string;
		}
		elseif ($return_format == "int") {
			return $interval;
		}
		else
			return "invalid";

	}

if(isset($_SESSION['user_id'])) {
	global $smarty;
	$smarty->assign('user', $_SESSION['user']);
	$smarty->assign('company', $_SESSION['company']);
	$smarty->assign('contacts_count', get_contacts_count());
	$smarty->assign('all_contacts_count', get_contacts_count()["all_contacts_count"]);
	$smarty->assign('notifications', get_notifications());
	if ($_SESSION['user']['is_admin'] == 1 || $_SESSION['user']['is_superadmin'] == 1)
		$smarty->assign('company_contacts_count', get_contacts_count(true));
}

?>
